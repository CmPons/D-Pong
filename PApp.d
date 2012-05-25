import derelict.sdl.sdl;
import derelict.util.compat;
import derelict.sdl.ttf;
import drawableObject;
import std.stdio;
import PTime, PFps, PInput, TextObject, PUtil, Actor, PlayStateManager;
import std.utf, std.conv, std.math;
import std.c.stdlib, std.c.time;

class PApp
{
private:
	bool			gameRunning;
	SDL_Event		event;
		
	PTime			ptime;
	PFps			pfps;
	PInput			pinput;

	PText			title;
	PText			pressAnyKey;
	PText			escToExit;
	PText			playerScoreText;
	PText			botScoreText;
	PText			youWin;
	PText			youLose;
	
	PlayStateManager playStateManager;

	PPlayer player;
	PBall	ballActor;
	PBot	bot;

	PDrawableObject ball;
	PDrawableObject playerPaddle;
	PDrawableObject background;
	PDrawableObject	botPaddle;

	const int xResolution;
	const int yResolution;
	const int bitsPerPixel;

	enum GameState
	{
		GS_TitleScreen,
		GS_PlayScreen,
		GS_PlayerWonScreen,
		GS_BotWonScreen,
	};

	GameState currentGameState;

public:
	static SDL_Surface*	surfDisplay;
	this()
	{
		this.xResolution	= 800;
		this.yResolution	= 600;
		this.bitsPerPixel	= 32;

		gameRunning			= true;
		surfDisplay			= null;

		ptime	= new PTime;
		pfps	= new PFps;
		pinput	= new PInput;

		player		= new PPlayer();
		ballActor	= new PBall();
		bot			= new PBot();

		title		= new PText("Pong", "./Gfx/Fonts/pirulen.ttf", 60, 400, 100);
		pressAnyKey	= new PText("Press Space to Continue", "./Gfx/Fonts/pirulen.ttf", 20, 400, 300);
		escToExit	= new PText("Press Escape to Exit at any Time", "./Gfx/Fonts/pirulen.ttf", 20, 400, 350);

		playerScoreText = new PText("Score: 0", "./Gfx/Fonts/pirulen.ttf", 20, cast(short)(xResolution * 0.1), cast(short)(yResolution * 0.1));
		botScoreText	= new PText("Score: 0", "./Gfx/Fonts/pirulen.ttf", 20, cast(short)(xResolution * 0.9), cast(short)(yResolution * 0.1));

		youWin = new PText("You Win!", "./Gfx/Fonts/pirulen.ttf", 60, 400, 100);
		youLose = new PText("Game Over!", "./Gfx/Fonts/pirulen.ttf", 60, 400, 100);
		
		background	= new PDrawableObject("./Gfx/Background.bmp");
		ball		= new PDrawableObject("./Gfx/Ball.Bmp"); 
		playerPaddle= new PDrawableObject("./Gfx/Paddle.bmp", player.GetPosition());
		botPaddle	= new PDrawableObject("./Gfx/Paddle.bmp", bot.GetPosition());

		playStateManager = new PlayStateManager;
	
		currentGameState = GameState.GS_TitleScreen;
	}
	
	void Run()
	{
		if( !Init() )
			return;
	
		if( !Load() )
			return;

		Loop();
		Cleanup();
	}

	bool Init()
	{
		if( !InitSubSystems() )
			return false;
		
		SDL_ShowCursor(SDL_DISABLE);
		
		InitLists();		
		InitTime();
		InitActors();
		InitDrawPositions();
		
		return true;
	}
	
	bool InitSubSystems()
	{
		DerelictSDL.load();
		DerelictSDLttf.load();
		
		if ( SDL_Init( SDL_INIT_EVERYTHING ) < 0 )
			return false;

		SDL_WM_SetCaption("D Pong", null);

		if ( ( surfDisplay = SDL_SetVideoMode( xResolution, yResolution, bitsPerPixel, SDL_HWSURFACE | SDL_DOUBLEBUF | SDL_FULLSCREEN ) ) == null )
			return false;

		if ( TTF_Init() == -1 )
			return false;

		return true;
	}

	void InitLists()
	{
		PDrawableObject.AddToList(ball);
		PDrawableObject.AddToList(playerPaddle);
		PDrawableObject.AddToList(botPaddle);

		PText.AddToList(title);
		PText.AddToList(pressAnyKey);
		PText.AddToList(escToExit);

		PActor.AddToList(player);
		PActor.AddToList(ballActor);
		PActor.AddToList(bot);
	}

	void InitTime()
	{
		ptime.InitNextTime();
		pfps.FPSInit();
	}
	
	void InitActors()
	{
		foreach(PActor; PActor.actorList)
			PActor.Init();
	}
	
	void InitDrawPositions()
	{
		ball.SetPosition( ballActor.GetPosition() );
		playerPaddle.SetPosition( player.GetPosition() );
		botPaddle.SetPosition( bot.GetPosition() );
	}

	bool Load()
	{
		foreach(drawableObject; PDrawableObject.objectList)
			if ( !drawableObject.Load() )
				return false;
		
		foreach(elem; PText.textList)
			if( !elem.Load() )
				return false;
		
		background.Load();
		playerScoreText.Load();
		botScoreText.Load();
		youWin.Load();
		youLose.Load();

		return true;
	}

	void Loop()
	{
		while ( gameRunning )
		{
			while ( SDL_PollEvent( &event ) )
			{
				switch ( event.type )
				{
					case SDL_QUIT:
						gameRunning = false;
						break;
					case SDL_KEYDOWN:
						switch ( event.key.keysym.sym )
						{
							case SDLK_RETURN:
								if ( ballActor.IsBallReset() )
									ballActor.ResetBallSpeed();
								break;
							case SDLK_ESCAPE:
								gameRunning = false;
								break;
							default:
								break;
						}
						break;
				case SDL_MOUSEMOTION:
						player.MouseMove( pinput );
						playerPaddle.SetPosition( player.GetPosition() );
						break;
				case SDL_MOUSEBUTTONDOWN:
						if ( event.button.type == SDL_MOUSEBUTTONDOWN )
							if ( event.button.button == SDL_BUTTON_LEFT )
								if ( ballActor.IsBallReset() )
									ballActor.ResetBallSpeed();
						break;
				default:
						break;
				}
			}
			UpdateGame();
			Render();

			ptime.PDelay( ptime.TimeLeft() );
			ptime.UpdateNextTime();
			
			pfps.FPSThink();
		}
	}

	void UpdateGame()
	{
		if ( currentGameState == GameState.GS_TitleScreen )
			if ( pinput.IsKeyReleased( event ) && pinput.KeyPressed( event, SDLK_SPACE ) )
				 currentGameState = GameState.GS_PlayScreen;

		if ( currentGameState == GameState.GS_PlayScreen )
		{
			//UpdatePlayer();
			UpdateBall();
			UpdateBot();
			UpdateScores();
		}

		if ( currentGameState == GameState.GS_PlayerWonScreen || 
			currentGameState == GameState.GS_BotWonScreen )
		{
			CheckPlayAgain();
		}
		pinput.UpdateMouseLocation();
	}

	void UpdateScores()
	{
		int playerScore;
		int botScore;
		
		string ScoreText;
			
		if ( ballActor.DidPlayerScore() )
		{
			ScoreText = "Score: ";
			playStateManager.PlayerScored();
			playStateManager.ReturnScores(playerScore, botScore);
			playerScoreText.UpdateMessageText(ScoreText ~ to!string(playerScore));
			//writeln("PlayerScore: ", playerScore);

			if ( playStateManager.DidPlayerWin() )
			{
				currentGameState = GameState.GS_PlayerWonScreen;
			}
			else 
			{
				ballActor.ResetBall();
			}
		}
		else if ( ballActor.DidBotScore() )
		{
			ScoreText = "Score: ";
			playStateManager.BotScored();
			playStateManager.ReturnScores(playerScore, botScore);
			botScoreText.UpdateMessageText(ScoreText ~ to!string(botScore));
			//writeln("BotScore: ", botScore);

			if ( playStateManager.DidBotWin() )
			{
				currentGameState = GameState.GS_BotWonScreen;
			}
			else 
			{
				ballActor.ResetBall();
			}

		}
	}
	
	void CheckPlayAgain()
	{
		if ( event.type == SDL_KEYDOWN )
		{
			if ( event.key.keysym.sym  == SDLK_SPACE )
			{
				int playerScore;
				int botScore;

				playStateManager.ResetScore();
				
				playStateManager.ReturnScores(playerScore, botScore);
				writeln("PlayerScore: ", playerScore);
				writeln("BotScore: ", botScore);

				playerScoreText.UpdateMessageText("Score: 0");
				botScoreText.UpdateMessageText("Score: 0");

				currentGameState = GameState.GS_PlayScreen;

				player.ResetPaddlePosition();
				bot.ResetPaddlePosition();
				bot.ResetMoveSpeed();
				ballActor.ResetBall();

				playerPaddle.SetPosition( player.GetPosition() );
				botPaddle.SetPosition( bot.GetPosition() );
				ball.SetPosition( ballActor.GetPosition() );
			}
		}
	}

	void UpdateBall()
	{
		PVector temp;

		temp = ballActor.GetMoveSpeed();

		ballActor.Move();
		CheckActorCollision();
		ball.SetPosition ( ballActor.GetPosition() );

		//writeln("Ball moveSpeed X: ", abs(temp.x));
		//writeln("Ball moveSpeed Y: ", abs(temp.y));
	}

	void UpdateBot()
	{
		int playerScore;
		int botScore;
		playStateManager.ReturnScores(playerScore, botScore);
		bot.AdjustBotDifficulty(botScore, playerScore);
		bot.Move( ballActor );
		botPaddle.SetPosition( bot.GetPosition() );
	}

	void CheckActorCollision()
	{
		for ( int i = 0; i < PActor.actorList.length - 1; i++)
			for ( int j = i + 1; j < PActor.actorList.length; j++)
				PActor.CheckCollision( PActor.actorList[i], PActor.actorList[j], pinput );
	}

	void Render()
	{
		background.Draw( surfDisplay );

		if ( currentGameState == GameState.GS_TitleScreen )
		{
			foreach(elem; PText.textList)
				elem.Draw( surfDisplay );
		}
		else if ( currentGameState == GameState.GS_PlayScreen )
		{
			foreach(drawableObject; PDrawableObject.objectList)
			{
				drawableObject.Draw( surfDisplay );
			}
			playerScoreText.Draw( surfDisplay );
			botScoreText.Draw( surfDisplay );
		}
		else if ( currentGameState == GameState.GS_PlayerWonScreen )
		{
			youWin.Draw( surfDisplay );
			pressAnyKey.Draw( surfDisplay);
		}
		else if ( currentGameState == GameState.GS_BotWonScreen )
		{
			youLose.Draw( surfDisplay );
			pressAnyKey.Draw( surfDisplay );
		}
		
		SDL_Flip( surfDisplay );
	}
	

	void Cleanup()
	{
		SDL_FreeSurface( surfDisplay );
		
		background.Cleanup();

		foreach(drawableObject; PDrawableObject.objectList)
			drawableObject.Cleanup();

		foreach(elem; PText.textList)
			elem.Cleanup();
		
		TTF_Quit();
		SDL_Quit();
		DerelictSDL.unload();
	}
	
	void GetResolution(out PVector resolution)
	{
		resolution.x = xResolution;
		resolution.y = yResolution;
	}
}

void main()
{
	PApp papp;
	papp = new PApp();
	papp.Run();
}
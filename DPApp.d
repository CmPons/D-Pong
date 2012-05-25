import SDLApp;
import DPInput;
import DPTime;
import std.stdio;
import DPDrawableObjectComponent;

class DPApp
{
private:
	SDLApp		sdlapp;
	DPInput		dpinput;
	DPTime		dptime;
	DPDrawableObjectComponent drawableObjectComponent;

	bool		gameRunning;
	const int	xResolution;
	const int	yResolution;
	const int	bitsPerPixel;

public:
	this()
	{
		gameRunning = true;
		xResolution = 800;
		yResolution = 600;
		bitsPerPixel = 32;
		
		sdlapp = new SDLApp(xResolution, yResolution, bitsPerPixel);
		dpinput = new DPInput;
		dptime = new DPTime;
		drawableObjectComponent = new DPDrawableObjectComponent;
	}
	
	void Run()
	{
		if( !Init() )
		{
			writeln("DPApp: Init() failed!");
			gameRunning = false;
		}

		InitSubSystems();
		Loop();
		Cleanup();
	}

	bool Init()
	{
		return sdlapp.Init();
	}
	
	void InitSubSystems()
	{
		drawableObjectComponent.Init();
		//drawableObjectComponent.Load();
	}

	void Loop()
	{
		dptime.InitNextTime();

		while(gameRunning)
		{
			if(sdlapp.PollQuit())
				gameRunning = false;

			UpdateGame();
			Render();

			dptime.DPDelay(dptime.TimeLeft());
			dptime.UpdateNextTime();
		}
	}

	void UpdateGame()
	{
	}

	void Render()
	{
		//drawableObjectComponent.Draw();
	}

	void Cleanup()
	{
		sdlapp.Cleanup();
	}
}

void main()
{
	DPApp dpapp;
	dpapp = new DPApp;

	dpapp.Run();
}
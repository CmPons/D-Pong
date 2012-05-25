module Actor;

import derelict.sdl.sdl;
import derelict.util.compat;
import PUtil;
import std.stdio, std.math;
import PInput;
import std.c.stdlib;



class PActor
{
private:
	PVector position;
	PVector resolution;

	PVector moveSpeed;

	int actorTextureXSize;
	int	actorTextureYSize;
	static int ballMoveSpeedCap;

	bool movingUp, movingDown, notMoving;

	static bool horizontalCollision, verticleCollision;

public:
	static PActor[] actorList;

	this()
	{
		this.actorTextureXSize = 0;
		this.actorTextureYSize = 0;

		this.position.x = 0;
		this.position.y = 0;

		this.moveSpeed.x = 0;
		this.moveSpeed.y = 0;

		this.resolution.x = 800;
		this.resolution.y = 600;

		movingUp = false;
		movingDown = false;
		notMoving = true;
		horizontalCollision = false;
		verticleCollision = false;

	}

	static this()
	{
		actorList = new PActor[0];
		ballMoveSpeedCap = 8;
	}
	
	abstract void Init();
	abstract void Move();
	abstract void Move(PVector moveTo);
	abstract bool CheckScreenCollision();
	
	static void CheckCollision(PActor object1, PActor object2, PInput pinput)
	{
		if ( CheckObjectCollision( object1, object2 ) )
		{
			AdjustMoveSpeed( object1, object2, pinput );
		}
	}
	
	//IF true we have collision
	static bool CheckObjectCollision(PActor object1, PActor object2)
	{
		PRect object1Rect;
		PRect object2Rect;
	
		object1Rect.Top = object1.position.y;
		object1Rect.Bottom = object1.position.y + object1.actorTextureYSize;
		object1Rect.Left = object1.position.x;
		object1Rect.Right = object1.position.x + object1.actorTextureXSize;

		object2Rect.Left = object2.position.x;
		object2Rect.Right = object2.position.x + object2.actorTextureXSize;
		object2Rect.Top = object2.position.y;
		object2Rect.Bottom = object2.position.y + object2.actorTextureYSize;
		
		return !( object1Rect.Bottom < object2Rect.Top || object1Rect.Top > object2Rect.Bottom || 
				 object1Rect.Right < object2Rect.Left || object1Rect.Left > object2Rect.Right);	
	}

	static void AdjustMoveSpeed(PActor object1, PActor object2, PInput pinput)
	{
		PVector prevMouseLocation = pinput.GetPrevMouseLocation();
		PVector currMouseLocation = pinput.GetCurrMouseLocation();

		if (typeid(object1) == typeid(PBall))
		{
			if (sgn(object1.moveSpeed.x) == sgn(object1.position.x - object2.position.x))
			{
				//Ball is moving away from paddle, don't bounce!
			}
			else
				object1.moveSpeed.x *= -1;	

			if ( typeid(object2) == typeid(PPlayer) )
			{
				ProcessBallPlayerCollision(object1, prevMouseLocation, currMouseLocation);				
			}
			else
			{
				ProcessBallBotCollision(object2, object1);
			}
		}
		else if (typeid(object2) == typeid(PBall))
		{
			
			if (sgn(object2.moveSpeed.x) == sgn(object2.position.x - object1.position.x))
			{
				//Ball is moving away from paddle, don't bounce!
			}
			else
				object2.moveSpeed.x *= -1;	
			
			if ( typeid(object1) == typeid(PPlayer) )
			{
				ProcessBallPlayerCollision(object2, prevMouseLocation, currMouseLocation);
			}
			else
			{
				ProcessBallBotCollision(object1, object2);
			}
		}		
	}

	static void ProcessBallPlayerCollision(PActor ball, PVector prevMouseLocation, PVector currMouseLocation)
	{

		int currentMoveSpeed;
		int nextMoveSpeed;

		currentMoveSpeed = ball.moveSpeed.y;
		nextMoveSpeed = prevMouseLocation.y  - currMouseLocation.y;

		//writeln("Current Y Speed: ", std.math.abs(currentMoveSpeed));
		//writeln("Next Y: ", std.math.abs(nextMoveSpeed));

		if ( std.math.abs(currentMoveSpeed) < std.math.abs(nextMoveSpeed) )
		{
			if ( std.math.abs(nextMoveSpeed) > ballMoveSpeedCap )
			{
				nextMoveSpeed = sgn(nextMoveSpeed) * ballMoveSpeedCap;
				ball.moveSpeed.y = nextMoveSpeed * -1; 
			}
			else
				ball.moveSpeed.y = nextMoveSpeed * -1; 
		}
		else
			ball.moveSpeed.y *= -1;
	}
	
	/*This processes collision and implements bot shots*/
	static void ProcessBallBotCollision(PActor bot, PActor ball)
	{
		//if (ball.moveSpeed.y > 0)
		//    ball.moveSpeed.y *= -1;
		//
		//writeln("Random Number: ", (rand() % 4) + 1);

		int randomNumber = ((rand() % 4) + 1);
		//writeln("Random Number: ", randomNumber);
		if (ball.moveSpeed.y > 0)
		{
			switch (randomNumber)
			{
				case 1:
					ball.moveSpeed.y *= -1;
					break;
				case 2:
					ball.moveSpeed.y *= 1;
					break;
				case 3:
					if ( std.math.abs(ball.moveSpeed.y) * 1.5 > ballMoveSpeedCap )
						ball.moveSpeed.y = -ballMoveSpeedCap;
					else
						ball.moveSpeed.y *= -1.5;
					break;
				case 4:
					if ( std.math.abs(ball.moveSpeed.y) * 1.5 > ballMoveSpeedCap )
						ball.moveSpeed.y = ballMoveSpeedCap;
					else
						ball.moveSpeed.y *= 1.5;
					break;
				default:
					break;
			}
		}
		else if ( ball.moveSpeed.y == 0 )
		{
			switch (randomNumber)
			{
				case 1:
					ball.moveSpeed.y = (rand() % 5) + 1;
					break;
				case 2:
					ball.moveSpeed.y = (rand() % 10) + 5;
					break;
				case 3:
					ball.moveSpeed.y = (rand() % 15) + 10;
					break;
				case 4:
					ball.moveSpeed.y = (rand() % 20) + 15;
					break;
				default:
					break;
			}
		}
		//writeln("Ball Move Speed: ", ball.moveSpeed.y);
	}
	
	/* Returns true if nextMoveSpeed is greater than currentMoveSpeed*/
	static bool CheckCurrentMoveSpeed(int currentMoveSpeed, int nextMoveSpeed)
	{
		if ( currentMoveSpeed < 0 )
			currentMoveSpeed *= -1;
		if ( nextMoveSpeed < 0 )
			nextMoveSpeed *= -1;

		if ( nextMoveSpeed > currentMoveSpeed )
			return true;
		else
			return false;
	}
	
	PVector GetPosition()
	{
		return position;
	}

	static void AddToList(PActor actorToAdd)
	{
		actorList ~= actorToAdd;
	}
}

class PPlayer : PActor
{
private:
public:
	this()
	{
		actorTextureXSize = 16;
		actorTextureYSize = 96;

		movingUp = false;
		movingDown = false;
		notMoving = true;

		moveSpeed.y = 20;

		position.x = cast(int)(resolution.x * 0.15);
		position.y = cast(int)(resolution.y * 0.5);
	}
	void Init()
	{
	}
	
	void Move()
	{
		return;
	}

	void MouseMove( PInput pinput )
	{
		PVector temp = pinput.MouseCoordinates( position );
		position.y = temp.y;
		CheckScreenCollision();
	}

	void Move(PVector vector)
	{
	}

	bool CheckScreenCollision()
	{
		if ( (position.y + actorTextureYSize) >= resolution.y )
		{
			position.y = resolution.y - actorTextureYSize;
			return true;
		}
	
		if ( position.y  <= 0 )
		{
			position.y = 0;
			return true;
		}
		return false;
	}

	void ResetPaddlePosition()
	{
		position.x = cast(int)(resolution.x * 0.15);
		position.y = cast(int)(resolution.y * 0.5);
	}
}

class PBall : PActor
{
private:
	bool ballReset;
public:
	this()
	{	
		actorTextureXSize = 16;
		actorTextureYSize = 16;
		moveSpeed.x = 0;
		position.x = cast(int)(resolution.x * 0.5);
		position.y = cast(int)(resolution.y * 0.5);
		ballReset = true;
	}
	void Init()
	{
	}

	void Move()
	{
		position.x += moveSpeed.x;
		position.y += moveSpeed.y;
		CheckScreenCollision();
	}

	void Move(PVector vector)
	{
	}

	PVector GetMoveSpeed()
	{
		return moveSpeed;
	}
	bool CheckScreenCollision()
	{
		if ( position.y <= 0 )
		{
			position.y = 0;
			moveSpeed.y *= -1;
			return true;
		}
		if ( position.y >= resolution.y )
		{
			position.y = resolution.y;
			moveSpeed.y *= -1;
			return true;
		}
		return false;
	}

	bool DidPlayerScore()
	{
		if ( position.x > resolution.x )
			return true;
		else
			return false;
	}

	bool DidBotScore()
	{
		if ( position.x < 0 )
			return true;
		else
			return false;
	}

	void ResetBall()
	{
		ballReset = true;
		position.y = cast(int)(resolution.y * 0.5);
		position.x = cast(int)(resolution.x * 0.5);
		moveSpeed.y = 0;
		moveSpeed.x = 0;
	}

	void ResetBallSpeed()
	{
		ballReset = false;
		moveSpeed.y = 0;
		moveSpeed.x = -5;
	}

	bool IsBallReset()
	{
		return ballReset;
	}
}

class PBot : PActor
{
	bool botHardMode;
	bool botEasyMode;

	this()
	{
		actorTextureXSize = 16;
		actorTextureYSize = 96;
		position.x = cast(int)(resolution.x * 0.85);
		position.y = cast(int)(resolution.y * 0.5);
		moveSpeed.y = 6;
	}

	void Init() 
	{
	}
		
	void Move (PVector vector)
	{
	}
	
	void AdjustBotDifficulty(int botScore, int playerScore)
	{
		int lastScoreDiff;
		int currScoreDiff;
		
		lastScoreDiff = currScoreDiff;
		currScoreDiff = playerScore - botScore;

		if ( std.math.abs(currScoreDiff) >= 4 && sgn(currScoreDiff) == 1)
		{
			botHardMode = true;
			botEasyMode = false;
			if ( moveSpeed.y == ballMoveSpeedCap )
				return;
			else
				moveSpeed.y += 1;
		}
		else if ( std.math.abs(currScoreDiff) >= 4 && sgn(currScoreDiff) == -1 )
		{
			botHardMode = false;
			botEasyMode = true;
			if ( moveSpeed.y == 5 )
				return;
			else
				moveSpeed.y -= 1;
		}

		if ( std.math.abs(currScoreDiff) <= 1 && botHardMode )
		{
			moveSpeed.y = 7;
			botHardMode = false;
		}

		if ( botEasyMode && std.math.abs(currScoreDiff) <= 2 )
		{
			moveSpeed.y = 6;
			botEasyMode = false;
		}

		writeln("Bot moveSpeed: ", moveSpeed.y);
	}

	void ResetMoveSpeed()
	{
		moveSpeed.y = 6;
	}

	void Move(PBall ball)
	{
		int botMiddle = 0;
		int ballMiddle = 0;
		int ballBotDifference = 0;

		botMiddle = position.y + actorTextureYSize / 2;
		ballMiddle = ball.position.y + ball.actorTextureYSize / 2;
		
		ballBotDifference = std.math.abs(botMiddle - ballMiddle);

		if ( ballBotDifference >= moveSpeed.y )
		{
			CompareAndMove(moveSpeed.y, ballMiddle, botMiddle);
		}
		else if ( ballBotDifference < moveSpeed.y && ballBotDifference > 8 )
		{
			CompareAndMove(8, ballMiddle, botMiddle );
		}
		else if ( ballBotDifference <= 8 )
		{
			CompareAndMove(1, ballMiddle, botMiddle  );
		}

		
		CheckScreenCollision();
	}

	void CompareAndMove(int moveSpeed, int ballMiddle, int botMiddle)
	{
		if ( ballMiddle < botMiddle )
			position.y -= moveSpeed;
		else if ( ballMiddle > botMiddle )
			position.y += moveSpeed;
	}

	void Move()
	{
	}

	bool CheckScreenCollision()
	{
		if ( position.y + actorTextureYSize >= resolution.y )
		{
			position.y = resolution.y - actorTextureYSize;
			return true;
		}

		if ( position.y  <= 0 )
		{
			position.y = 0;
			return true;
		}
		return false;
	}

	void ResetPaddlePosition()
	{
		position.x = cast(int)(resolution.x * 0.85);
		position.y = cast(int)(resolution.y * 0.5);
	}
}
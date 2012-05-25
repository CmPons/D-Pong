import derelict.sdl.sdl;
import std.stdio;

class PFps
{
private:
	float alpha;
	int getTicks, frameTimeDelta, frameTimeLast;
	float frameTime, framesPerSecond;

public:
	void FPSInit()
	{
		alpha = 0.2;
		getTicks = 0;
		frameTimeDelta = 0;
		frameTimeLast = 0;
		frameTime = 0;
		framesPerSecond = 0;
	}

	void FPSThink()
	{
		getTicks = SDL_GetTicks();
		frameTimeDelta = getTicks - frameTimeLast;
		frameTimeLast = getTicks;

		frameTime = alpha * frameTimeDelta + ( 1.0 - alpha ) * frameTime;

		framesPerSecond = 1000.0 / frameTime;

		//writeln("Frames: ", framesPerSecond);
	}

	float GetFramesPerSecond()
	{
		return framesPerSecond;
	}

}

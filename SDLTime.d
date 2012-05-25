import derelict.sdl.sdl;

class SDLTime
{
private:
	const uint tickInterval;
	static uint next_time;

public:
	this()
	{
		tickInterval = 17;
	}

	/*This returns the time left before now == next_time*/
	uint TimeLeft()
	{
		uint now;

		now = DPGetTicks();

		if(next_time <= now)
			return 0;
		else
			return next_time - now;
	}

	/*This returns the amount of ticks*/
	uint DPGetTicks()
	{
		return SDL_GetTicks();
	}

	/*This funciton initialzies next_time by setting it to DPGetTicks plus the Tick Interval*/
	void InitNextTime()
	{
		next_time = DPGetTicks() + tickInterval;
	}

	/*This function updates next_time by adding the tick_interval*/
	void UpdateNextTime()
	{
		next_time += tickInterval;
	}

	/*This delays the program for a certain amount of milliseconds*/
	void DPDelay(uint timeleft)
	{
		SDL_Delay(timeleft);
	}
}
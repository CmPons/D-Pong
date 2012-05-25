import derelict.sdl.sdl;

class PTime
{
private:
	const int	TICKINTERVAL;
	int			nextTime;
public:
	
	this()
	{
		TICKINTERVAL = 8;
		nextTime = 0;
	}

	int GetTicks()
	{
		return SDL_GetTicks();
	}

	int TimeLeft()
	{
		int now;

		now = GetTicks();

		if( nextTime <= now )
			return 0;
		else
			return nextTime - now;
	}
	
	void PDelay( int timeLeft )
	{
		SDL_Delay( timeLeft );
	}
		
	void InitNextTime()
	{
		nextTime = GetTicks() + TICKINTERVAL;
	}

	void UpdateNextTime()
	{
		nextTime += TICKINTERVAL;
	}
}
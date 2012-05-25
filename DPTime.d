import SDLTime;

class DPTime
{
private:
	SDLTime sdltime;

public:
	this()
	{
		sdltime = new SDLTime;
	}

	/*This returns the time left before now == next_time*/
	uint TimeLeft()
	{
		return sdltime.TimeLeft();
	}

	/*This returns the amount of ticks*/
	uint DPGetTicks()
	{
		return sdltime.DPGetTicks();
	}

	/*This function initializes next_time by setting it equal to the amount of ticks passed
	by the tick interval */
	void InitNextTime()
	{
		sdltime.InitNextTime();
	}

	/*This funcion updates next time by adding the tickInterval*/
	void UpdateNextTime()
	{
		sdltime.UpdateNextTime();
	}

	/*This delays the program for a certain amount of milliseconds*/
	void DPDelay(uint timeleft)
	{
		sdltime.DPDelay(timeleft);
	}
}
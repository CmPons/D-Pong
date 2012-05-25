import std.stdio;
import std.c.stdlib;
import derelict.sdl.sdl;

class SDLApp
{
private:
	const int			xResolution;
	const int			yResolution;
	const int			bitsPerPixel;


public:
	static SDL_Event	event;
	static SDL_Surface	* SurfDisplay;
	this(const int xResolution, const int yResolution, const int bitsPerPixel)
	{
		this.xResolution	= xResolution;
		this.yResolution	= yResolution;
		this.bitsPerPixel	= bitsPerPixel;
		this.SurfDisplay	= null;
	}

	bool Init()
	{
		DerelictSDL.load();

		if( SDL_Init(SDL_INIT_EVERYTHING) < 0 )
			return false;

		if( (SurfDisplay = SDL_SetVideoMode(xResolution, yResolution, bitsPerPixel, SDL_HWSURFACE | SDL_DOUBLEBUF)) == null )
			return false;

		SDL_WM_SetCaption("D Pong", null);

		return true;
	}

	bool PollQuit()
	{
		while(SDL_PollEvent(&event))
		{
			switch(event.type)
			{
				case SDL_QUIT:
					return true;
					break;
				default:
					return false;
					break;
			}
		}
		return false;
	}
	
	SDL_Event * GetEvent() @property
	{
		return &event;
	}

	void Cleanup()
	{
		SDL_FreeSurface(SurfDisplay);
		SDL_Quit();
		DerelictSDL.unload();
	}

}


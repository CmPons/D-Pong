import derelict.sdl.sdl;
import std.stdio;

class SDLDrawableObject
{
	SDL_Surface * Surface;
	
	this()
	{
		this.Surface = null;
	}
	
	~this()
	{
		SDL_FreeSurface(Surface);
	}

	SDL_Surface * Load(char * file)
	{
		SDL_Surface * Temp = null;

		if((Temp = SDL_LoadBMP(file)) == null)
		{
			writeln("SDLDrawableObject: Load: The file could not be found!");
			return null;
		}

		Surface = SDLDisplayFormat(Temp);

		SDL_FreeSurface(Temp);

		return Surface;
	}

	bool SDLDraw(SDL_Surface * Destination, SDL_Surface * Source, short x, short y)
	{
		if(Destination == null || Source == null)
		{
			writeln("SDLDrawableObject: Draw: Error Drawing the texture!");
			return false;
		}

		SDL_Rect DestR;

		DestR.x = x;
		DestR.y = y;

		SDL_BlitSurface(Source, null, Destination, &DestR);

		return true;
	}

	SDL_Surface * SDLDisplayFormat(SDL_Surface * Surface)
	{
		return SDL_DisplayFormat(Surface);
	}

	void SDLFlipSurface(SDL_Surface * Surface)
	{
		SDL_Flip(Surface);
	}
}
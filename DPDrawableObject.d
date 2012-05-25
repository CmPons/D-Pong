import derelict.sdl.sdl;
import SDLDrawableObject;
import DPIDrawableObject;

class DPDrawableObject : IDrawableObject
{
	SDL_Surface			* Surface;
	char				* filename;
	SDLDrawableObject	SDLDrawObject;
	
	this()
	{
		this.Surface = null;
		this.filename = null;
		this.SDLDrawObject = new SDLDrawableObject;
	}
	~this()
	{
		SDL_FreeSurface(Surface);
	}

	SDL_Surface * LoadImage(char * file)
	{
		return SDLDrawObject.Load(file);
	}

	bool Draw(SDL_Surface * Destination, SDL_Surface * Source, short x, short y)
	{
		return SDLDrawObject.SDLDraw(Destination, Source, x, y);
	}

	SDL_Surface * DPDisplayFormat(SDL_Surface * temp)
	{
		return SDLDrawObject.SDLDisplayFormat(temp);
	}

	void DPFlipSurface(SDL_Surface * Surface)
	{
		SDLDrawObject.SDLFlipSurface(Surface);
	}
}
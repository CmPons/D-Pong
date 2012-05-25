import std.stdio;
import derelict.sdl.sdl;

interface IDrawableObject
{
	SDL_Surface * LoadImage(char * file);
	bool Draw(SDL_Surface * Destination, SDL_Surface * Source, short x, short y);
	SDL_Surface * DPDisplayFormat(SDL_Surface * Surface);
	void DPFlipSurface(SDL_Surface * Surface);
}
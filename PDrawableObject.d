module drawableObject;

import derelict.sdl.sdl;
import derelict.util.compat;
import std.stdio;
import PUtil;

class PDrawableObject
{
private:
	SDL_Surface *  objectSurface;
	const string filename;
	
	int xPosition;
	int yPosition;

	SDL_Surface * LoadFile()
	{
		SDL_Surface* surfTemp, surfReturn;

		if ((surfTemp = SDL_LoadBMP(toCString(filename))) == null) 
		{
			throw new Exception("Could not open file " ~ filename ~ ": " ~ toDString(SDL_GetError()));
		}

		surfReturn = SDL_DisplayFormat(surfTemp);
		SDL_FreeSurface(surfTemp);

		return surfReturn;
	}

public:
	static PDrawableObject[] objectList;
	
	this(const string filename)
	{
		this.xPosition = 0;
		this.yPosition = 0;
		this.filename = filename;
		objectSurface = null;
	}

	this(const string filename, PVector position)
	{
		this(filename);
		this.xPosition = position.x;
		this.yPosition = position.y;
		objectSurface = null;
	}

	static this()
	{
		objectList = new PDrawableObject[0];
	}

	bool Load()
	{
		if ( (objectSurface = LoadFile()) == null )
			return false;
		else
			return true;
	}

	bool Draw(SDL_Surface * Destination)
	{

		if(Destination == null || objectSurface == null)
		{
			writeln( "PApp: Draw: Destination or Source is NULL!" );
			return false;
		}

		SDL_Rect DestR;

		DestR.x = cast(short)xPosition;
		DestR.y = cast(short)yPosition;

		SDL_BlitSurface(objectSurface, null, Destination, &DestR);

		return true;
	}

	void Cleanup()
	{
		SDL_FreeSurface(objectSurface);
	}
	
	void SetPosition(int xPosition, int yPosition)
	{
		this.xPosition = xPosition;
		this.yPosition = yPosition;
	}

	void SetPosition(PVector position)
	{
		this.xPosition = position.x;
		this.yPosition = position.y;
	}

	static void AddToList(PDrawableObject dObject)
	{
		objectList ~= dObject;
	}
}

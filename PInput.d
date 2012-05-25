import derelict.sdl.sdl;
import PUtil;
import std.stdio;

class PInput
{
private:
	PVector prevMouseLocation;
	PVector currMouseLocation;
public:
	bool IsKeyDown ( ref SDL_Event event )
	{
		return ( event.type == SDL_KEYDOWN );
	}

	bool IsKeyReleased ( ref SDL_Event event )
	{
		return ( event.type == SDL_KEYUP );
	}

	bool KeyPressed ( ref SDL_Event event, SDLKey Key )
	{
		return ( event.key.keysym.sym == Key );
	}

	 PVector MouseCoordinates( PVector location )
	{
		SDL_GetMouseState(  &location.x, &location.y );
		return location;
	}

	void UpdateMouseLocation()
	{
		PVector temp;
		prevMouseLocation = currMouseLocation;
		currMouseLocation = MouseCoordinates( temp );
	}
	
	PVector GetPrevMouseLocation()
	{
		return prevMouseLocation;
	}

	PVector GetCurrMouseLocation()
	{
		return currMouseLocation;
	}
}
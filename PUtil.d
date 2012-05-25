import derelict.sdl.sdl;
import derelict.util.compat;
import drawableObject;

struct PVector
{
	int x;
	int y;
}

struct PRect
{
	int Top;
	int Bottom;
	int Left;
	int Right;
}


int AbsoluteValue(int n)
{
	if ( n < 0 )
		n *= -1;

	return n;
}


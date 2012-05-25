import derelict.sdl.sdl;
import SDLApp;

class SDLInput
{
private:
	SDLApp sdlapp;
public:
	this()
	{
	}

	enum DPSDLKeys
	{
		DPSDLK_SPACE	= SDLK_SPACE,
		DPSDLK_RETURN	= SDLK_RETURN,
		DPSDLK_UP		= SDLK_UP,
		DPSDLK_DOWN		= SDLK_DOWN
	}

	bool KeyPressed(SDLKey key)
	{
		auto event = sdlapp.event;

		if(event.type == SDL_KEYDOWN && event.key.keysym.sym == key)
			return true;
		else
			return false;
	}

	bool KeyReleased(SDLKey key)
	{
		auto event = sdlapp.event;

		if(event.type == SDL_KEYUP && event.key.keysym.sym == key)
			return true;
		else
			return false;
	}
}
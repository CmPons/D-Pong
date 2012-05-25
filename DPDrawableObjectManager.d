import derelict.sdl.sdl;
import std.stdio;
import DPDrawableObject;
import SDLApp;

class DrawableObjectManager
{
private:
	DPDrawableObject[] RenderObjects;
	int index;
	SDLApp sdlapp;

public:
	this()
	{
		index = 0;
		RenderObjects = null;
	}

	void Add(DPDrawableObject DPObject)
	{
		assert(DPObject !is null);

		RenderObjects[index] = DPObject;
		index++;
	}

	bool Remove()
	{
		if(RenderObjects[index] !is null)
		{
			RenderObjects[index] = null;
			index--;
			return true;
		}
		else
			return false;
	}
	
	void Load()
	{
		foreach(elem; RenderObjects)
		{
			if(!elem.LoadImage(elem.filename))
			{
				writeln("DPDrawableObjectManager: Load(): Error Loading the File!");
				return;
			}
		}
	}
	
	void Draw()
	{
		auto Destination = sdlapp.SurfDisplay;

		foreach(elem; RenderObjects)
		{
			if(Destination != null)
			{
				if(!elem.Draw(Destination, elem.Surface, 0, 0))
				{
					writeln("DPDrawableObjectManager: Load(): Error Drawing the texture!");
					return;
				}
			else
				writeln("DPDrawableObjectManager: Load(): Destination is null!!");
				return;
			}
		}
	}
}
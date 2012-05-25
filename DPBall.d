import DPDrawableObject;
import std.utf;

class DPBall : DPDrawableObject
{
	char * filename;
	
	this()
	{
		this.filename = toUTFz!(char *)("Test.bmp");
	}
}
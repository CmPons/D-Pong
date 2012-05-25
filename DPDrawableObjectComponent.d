import DPDrawableObjectManager;
import DPDrawableObject;
import DPBall;

class DPDrawableObjectComponent
{
private:
	DrawableObjectManager ObjectManager;
	DPBall Ball;

public:
	this()
	{
		Ball = new DPBall;
		ObjectManager = new DrawableObjectManager;
	}
	
	void Init()
	{
		ObjectManager.Add(Ball);
	}

	void Load()
	{
		ObjectManager.Load();
	}

	void Draw()
	{
		ObjectManager.Draw();
	}
}
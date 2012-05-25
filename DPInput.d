import SDLInput;

class DPInput
{
private:
	SDLInput sdlinput;

public:
	enum DPKey
	{
		DPK_SPACE	= sdlinput.DPSDLKeys.DPSDLK_SPACE,
		DPK_RETURN	= sdlinput.DPSDLKeys.DPSDLK_RETURN,
		DPK_UP		= sdlinput.DPSDLKeys.DPSDLK_UP,
		DPK_DOWN	= sdlinput.DPSDLKeys.DPSDLK_DOWN
	}

	this()
	{
		sdlinput = new SDLInput;
	}

	bool KeyPressed(DPKey key)
	{
		return sdlinput.KeyPressed(key);
	}

	bool KeyReleased(DPKey key)
	{
		return sdlinput.KeyReleased(key);
	}
}
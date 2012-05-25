module TextObject;

import derelict.sdl.sdl;
import derelict.sdl.ttf;
import derelict.util.compat;

class PText
{
private:
	SDL_Surface*	message;
	TTF_Font*		font;
	short			xPosition;
	short			yPosition;
	string			messageText;
	string			fontFileLocation;
	int				fontSize;	

	SDL_Color textColor = { 255, 255, 255 };

public:
	
	static PText[] textList;

	this(string messageText, string fontFileLocation, int fontSize, short xPosition, short yPosition)
	{
		this.message	= null;
		this.font		= null;

		this.messageText		= messageText;
		this.fontFileLocation	= fontFileLocation;		

		this.fontSize	= fontSize;

		this.xPosition	= xPosition;
		this.yPosition	= yPosition;
	}

	static this()
	{
		textList = new PText[0];
	}

	bool Load()
	{
		font = TTF_OpenFont( toCString(fontFileLocation), fontSize );

		if ( font == null )
			return false;

		message = TTF_RenderText_Solid( font, toCString(messageText), textColor );

		if ( message == null )
			return false;

		return true;
	}

	void UpdateMessageText(string messageText)
	{
		this.messageText = messageText;
		message = TTF_RenderText_Solid( font, toCString(messageText), textColor );
	}

	bool Draw( SDL_Surface * Destination )
	{
		if ( Destination == null || message == null )
			return false;

		SDL_Rect offset;
		
		offset.x = cast(short)(xPosition - message.w / 2);
		offset.y = cast(short)(yPosition - message.h / 2);

		SDL_BlitSurface ( message, null, Destination, &offset );

		return true;
	}

	void Cleanup()
	{
		SDL_FreeSurface( message );
		TTF_CloseFont( font );
	}

	static void AddToList(PText ptext)
	{
		textList ~= ptext;
	}
}
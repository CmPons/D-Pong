import derelict.sdl.sdl;
import derelict.util.compat;

class PlayStateManager
{
private:
	int playerScore;
	int botScore;
	int maxScore;
public:
	this()
	{
		this.playerScore = 0;
		this.botScore = 0;
		this.maxScore = 10;
	}
	
	bool DidPlayerWin()
	{
		if ( playerScore == maxScore && botScore < maxScore )
			return true;
		else
			return false;
	}

	bool DidBotWin()
	{
		if ( botScore == maxScore && playerScore < maxScore )
			return true;
		else
			return false;
	}

	void PlayerScored()
	{
		playerScore += 1;
	}

	void BotScored()
	{
		botScore += 1;
	}

	void ReturnScores ( out int playerScore, out int botScore )
	{
		playerScore = this.playerScore;
		botScore = this.botScore;
	}

	void ResetScore()
	{
		this.playerScore = 0;
		this.botScore = 0;
	}
}
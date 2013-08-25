package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class ResultsState extends FlxState
	{
		private var _score:int;
		private var _gameOverText:FlxText;
		private var _scoreText:FlxText;
		
		public function ResultsState(score:int)
		{
			_score = score;
		}
		
		public override function create():void
		{
			var screenCenterY:int = FlxG.height / 2;
			_gameOverText = new FlxText(0, screenCenterY - 30, 200, "GAME OVER");
			_gameOverText.color = 0xFF000000;
			_gameOverText.width = FlxG.width;
			_gameOverText.alignment = "center";
			add(_gameOverText);
			
			_scoreText = new FlxText(0, screenCenterY - 10, 200, "SCORE: " + _score.toString());
			_scoreText.color = 0xFF000000;
			_scoreText.width = FlxG.width;
			_scoreText.alignment = "center";
			add(_scoreText);
		}
		
		public override function update():void
		{
			if (FlxG.keys.SPACE)
				FlxG.switchState(new MenuState);
			if (FlxG.keys.R)
				FlxG.switchState(new PlayState);
		}
	}

}
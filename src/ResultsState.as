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
		private var _target:int;
		private var _level:int;
		private var _gameOverText:FlxText;
		private var _scoreText:FlxText;
		private var _targetText:FlxText;
		private var _levelText:FlxText;
		private var _restartText:FlxText;
		private var _menuText:FlxText;
		
		public function ResultsState(score:int, target:int, level:int)
		{
			_score = score;
			_target = target;
			_level = level;
		}
		
		public override function create():void
		{
			var screenCenterY:int = FlxG.height / 2;
			_gameOverText = new FlxText(0, screenCenterY - 50, 300, "GAME OVER");
			centerAndColorText(_gameOverText);
			add(_gameOverText);
			
			_scoreText = new FlxText(0, screenCenterY - 30, 300, "SCORE: " + _score.toString());
			centerAndColorText(_scoreText);
			add(_scoreText);
			
			_targetText = new FlxText(0, screenCenterY - 10, 300, "YOU NEEDED: " + _target.toString());
			centerAndColorText(_targetText);
			add(_targetText);
			
			_levelText = new FlxText(0, screenCenterY + 10, 300, "YOU WERE AT LEVEL " + _level.toString());
			centerAndColorText(_levelText);
			add(_levelText);
			
			_restartText = new FlxText(0, screenCenterY + 50, 300, "PRESS R TO RESTART");
			centerAndColorText(_restartText);
			add(_restartText);
			
			_menuText = new FlxText(0, screenCenterY + 70, 300, "PRESS SPACE TO GO TO MENU");
			centerAndColorText(_menuText);
			add(_menuText);
		}
		
		public override function update():void
		{
			if (FlxG.keys.SPACE)
				FlxG.switchState(new MenuState);
			if (FlxG.keys.R)
				FlxG.switchState(new PlayState);
		}
		
		private function centerAndColorText(text:FlxText):void
		{
			text.color = 0xFF000000;
			text.width = FlxG.width;
			text.alignment = "center";
		}
	}

}
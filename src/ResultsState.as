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
			add(BackgroundParticle.backgroundParticles);
			
			var screenCenterY:int = FlxG.height / 2;
			_gameOverText = new FlxText(0, screenCenterY - 50, 300, "GAME OVER");
			Utils.centerAndColorText(_gameOverText);
			add(_gameOverText);
			
			_scoreText = new FlxText(0, screenCenterY - 30, 300, "SCORE: " + _score.toString());
			Utils.centerAndColorText(_scoreText);
			add(_scoreText);
			
			_targetText = new FlxText(0, screenCenterY - 10, 300, "YOU NEEDED: " + _target.toString());
			Utils.centerAndColorText(_targetText);
			add(_targetText);
			
			_levelText = new FlxText(0, screenCenterY + 10, 300, "YOU WERE AT LEVEL " + _level.toString());
			Utils.centerAndColorText(_levelText);
			add(_levelText);
			
			_restartText = new FlxText(0, screenCenterY + 50, 300, "PRESS R TO RESTART");
			Utils.centerAndColorText(_restartText);
			add(_restartText);
			
			_menuText = new FlxText(0, screenCenterY + 70, 300, "PRESS SPACE TO GO TO MENU");
			Utils.centerAndColorText(_menuText);
			add(_menuText);
		}
		
		public override function update():void
		{
			BackgroundParticle.getNewBackgroundParticle();
			if (FlxG.keys.SPACE)
				FlxG.switchState(new MenuState);
			if (FlxG.keys.R)
				FlxG.switchState(new PlayState);
			super.update();
		}
	}

}
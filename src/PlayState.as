package  
{
	import enemies.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class PlayState extends FlxState 
	{
		private const POINTS_PER_LEVEL:int = 1000;
		
		private static var _instance:PlayState;
		
		public static function get player():Player
		{
			return _instance == null ? null : _instance._player;
		}
		
		private var _player:Player;
		private var _enemies:FlxGroup;
		private var _levelCounter:int;
		private var _pointTarget:int;
		private var _timer:Number;
		private var _timerText:FlxText;
		private var _scoreText:FlxText;
		
		public override function create():void
		{
			_instance = this;
			FlxG.bgColor = 0xff8cc5d9;
			add(Bullet.playerBullets);
			add(Bullet.enemyBullets);
			_enemies = new FlxGroup;
			_enemies.add(Turret.turrets);
			_enemies.add(Fighter.fighters);
			add(_enemies);
			_player = new Player(100, 100);
			add(_player);
			_levelCounter = 0;
			levelUp();
			_timer = 0;
			_timerText = new FlxText(10, FlxG.height - 50, 100);
			_scoreText = new FlxText(10, 10, 100);
			add(_timerText);
			add(_scoreText);
			
			Turret.getNewTurret(10, 10);
			Fighter.getNewFighter(30, 30);
		}
		
		override public function destroy():void 
		{
			_instance = null;
			super.destroy();
		}
		
		public override function update():void
		{
			handleInput();
			handleCollisions();
			handleScore();
			super.update();
		}
		
		private function handleInput():void
		{
			var xDirection:int = 0;
			var yDirection:int = 0;
			if (FlxG.keys.LEFT)
				--xDirection;
			if (FlxG.keys.RIGHT)
				++xDirection;
			if (FlxG.keys.UP)
				--yDirection;
			if (FlxG.keys.DOWN)
				++yDirection;
			
			_player.move(xDirection, yDirection);
			
			if (FlxG.keys.SPACE)
				_player.shoot();
		}
		
		private function handleCollisions():void
		{
			FlxG.overlap(_player, Bullet.enemyBullets, Player.bulletCollision);
			FlxG.overlap(_enemies, Bullet.playerBullets, Enemy.bulletCollision);
		}
		
		private function handleScore():void
		{
			_timer += FlxG.elapsed;
			if (_timer >= 10)
			{
				_timer = 0;
				if (FlxG.score >= _pointTarget)
					levelUp();
				else
					;// end the game
			}
			_timerText.text = (10 - Math.floor(_timer)).toString();
			_scoreText.text = FlxG.score.toString();
		}
		
		private function levelUp():void
		{
			_pointTarget = FlxG.score + (POINTS_PER_LEVEL * ++_levelCounter);
		}
	}

}
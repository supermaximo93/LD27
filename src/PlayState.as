package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class PlayState extends FlxState 
	{
		private const POINTS_PER_LEVEL:int = 1000;
		
		private var _player:Player;
		private var _levelCounter:int;
		private var _pointTarget:int;
		private var _timer:Number;
		
		public override function create():void
		{
			add(Bullet.playerBullets);
			add(Bullet.enemyBullets);
			_player = new Player(100, 100);
			add(_player);
			var path:Vector.<FlxPoint> = new Vector.<FlxPoint>;
			path.push(new FlxPoint(10, 10), new FlxPoint(50, 50), new FlxPoint(10, 140), new FlxPoint(300, 200), new FlxPoint(450, 300), new FlxPoint(600, 10));
			add(new Enemy(10, 10, 10, path, 800));
			_levelCounter = 0;
			levelUp();
			_timer = 0;
		}
		
		override public function update():void
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
			FlxG.collide(_player, Bullet.enemyBullets, Player.bulletCollision);
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
		}
		
		private function levelUp():void
		{
			_pointTarget = FlxG.score + (POINTS_PER_LEVEL * ++_levelCounter);
		}
	}

}
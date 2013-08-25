package enemies 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Fighter extends Enemy 
	{
		[Embed(source = "../assets/images/fighter.png")] private static var sprite:Class
		
		private static const PATHS:Vector.<Vector.<FlxPoint>> = new Vector.<Vector.<FlxPoint>>;
		private static const HEALTH:int = 3;
		private static const SPEED:Number = 200;
		private static const SHOOT_TIME:Number = 0.7;
		private static const BULLET_SPEED:Number = 400;
		private static const EXPLOSION_COLORS:Array = [0xFF343399, 0xFF007DFF, 0xFF0300FF, 0xFF383762];
		
		private static function initialize():void
		{
			for (var i:int = 0; i < PATH_STRINGS.length; ++i)
				PATHS.push(Utils.stringToPath(PATH_STRINGS[i]));
		}
		
		{
			initialize();
		}
		
		private static var _fighers:FlxGroup = new FlxGroup();
		
		public static function get fighters():FlxGroup
		{
			return _fighers;
		}
		
		public static function getNewFighter(x:Number, y:Number):Fighter
		{
			var fighter:Fighter = _fighers.getFirstAvailable(Fighter) as Fighter;
			if (fighter == null)
			{
				fighter = new Fighter(x, y);
				_fighers.add(fighter);
			}
			else
				fighter.resetFighter(x, y);
			return fighter;
		}
		
		private var _shootTimer:Number;
		
		protected override function get explosionColors():Array
		{
			return EXPLOSION_COLORS;
		}
		
		public function Fighter(x:Number, y:Number) 
		{
			super(x, y, HEALTH, PATHS[int(Math.floor(Math.random() * PATHS.length))], REVERSE, SPEED, sprite);
			resetFighter(x, y, true);
		}
		
		public function resetFighter(x:Number, y:Number, calledFromConstructor:Boolean = false):void
		{
			if (!calledFromConstructor)
				resetEnemy(x, y, HEALTH, PATHS[int(Math.floor(Math.random() * PATHS.length))], REVERSE, SPEED);
			_shootTimer = 0;
		}
		
		public override function update():void 
		{
			_shootTimer += FlxG.elapsed;
			if (_shootTimer >= SHOOT_TIME)
			{
				_shootTimer = 0;
				Bullet.getNewEnemyBullet(x + (width / 2), y + height, new FlxPoint(0, BULLET_SPEED), 0, 0xFF343399);
			}
			super.update();
		}
		
		private static const PATH_STRINGS:Array = [
			"0,0; 300,0",
			"0,0; 13,-22; 36,-36; 58,-22; 72,0; 85,22; 108,36; 130,22; 144,0; 157,-22; 180,-36; 202,-22; 216,0; 230,22; 252,36; 275,22; 288,0"
		];
	}

}
package enemies 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Fighter extends Enemy 
	{
		private static const PATHS:Vector.<Vector.<FlxPoint>> = new Vector.<Vector.<FlxPoint>>;
		private const HEALTH:int = 3;
		private const SPEED:Number = 200;
		private const SHOOT_TIME:Number = 0.7;
		private const BULLET_SPEED:Number = 800;
		
		private static function initialize():void
		{
			for (var i:int = 0; i < PATH_STRINGS.length; ++i)
			{
				var path:Vector.<FlxPoint> = new Vector.<FlxPoint>;
				var pointStrings:Array = (PATH_STRINGS[i] as String).split("; ");
				for (var pointStringIndex:int = 0; pointStringIndex < pointStrings.length; ++pointStringIndex)
				{
					var xy:Array = (pointStrings[pointStringIndex] as String).split(",");
					path.push(new FlxPoint(parseFloat(xy[0]), parseFloat(xy[1])));
				}
				PATHS.push(path);
			}
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
		
		public function Fighter(x:Number, y:Number) 
		{
			super(x, y, HEALTH, PATHS[int(Math.floor(Math.random() * PATHS.length))], SPEED);
			makeGraphic(30, 30, 0xffffffff);
			resetFighter(x, y, true);
		}
		
		public function resetFighter(x:Number, y:Number, calledFromConstructor:Boolean = false):void
		{
			if (!calledFromConstructor)
				resetEnemy(x, y, HEALTH, PATHS[int(Math.floor(Math.random() * PATHS.length))], SPEED);
			_shootTimer = 0;
		}
		
		override public function update():void 
		{
			_shootTimer += FlxG.elapsed;
			if (_shootTimer >= SHOOT_TIME)
			{
				_shootTimer = 0;
				Bullet.getNewEnemyBullet(x + (width / 2), y + height, new FlxPoint(0, BULLET_SPEED));
			}
			super.update();
		}
		
		private static const PATH_STRINGS:Array = [
			"10,10; 600,10",
			"10,10; 100,100; 200,10; 300,100; 400,10"
		];
	}

}
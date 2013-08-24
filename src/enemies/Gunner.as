package enemies 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Gunner extends Enemy 
	{
		private const PATH:Vector.<FlxPoint> = Utils.stringToPath("120,50; 520,50; 230, 50; 230,480");
		private const HEALTH:int = 10;
		private const SPEED:Number = 200;
		private const STOP_TIME:Number = 2.5;
		private const BULLET_VELOCITY:FlxPoint = new FlxPoint(100, 400);
		
		private static var _gunners:FlxGroup = new FlxGroup;
		
		public static function get gunners():FlxGroup
		{
			return _gunners;
		}
		
		public static function getNewGunner(x:Number, y:Number):Gunner
		{
			var gunner:Gunner = _gunners.getFirstAvailable(Gunner) as Gunner;
			if (gunner == null)
			{
				gunner = new Gunner(x, y);
				_gunners.add(gunner);
			}
			else
				gunner.resetGunner(x, y);
			return gunner;
		}
		
		private var _tempPath:Vector.<FlxPoint>;
		private var _tempVelocity:FlxPoint;
		private var _stopTimer:Number;
		
		public function Gunner(x:Number, y:Number) 
		{
			super(x, y, HEALTH, PATH, STOP, SPEED);
			resetGunner(x, y, true);
			_tempVelocity = new FlxPoint;
		}
		
		public function resetGunner(x:Number, y:Number, calledFromConstructor:Boolean = false):void
		{
			if (!calledFromConstructor)
				super.resetEnemy(x, y, HEALTH, PATH, STOP, SPEED);
			_tempPath = null;
			_stopTimer = 0;
			_moveDown = false;
		}
		
		public override function update():void 
		{
			updateStopTimer();
			super.update();
		}
		
		protected override function onPathPointReached():void 
		{
			_tempPath = _path;
			_tempVelocity.copyFrom(velocity);
			velocity.x = 0;
			velocity.y = 0;
			_path = null;
			_stopTimer = STOP_TIME;
		}
		
		private function updateStopTimer():void
		{
			if (_stopTimer > 0)
			{
				_stopTimer -= FlxG.elapsed;
				if (_stopTimer <= 0)
				{
					if (_tempPath == null)
						_moveDown = true;
					else
					{
						_path = _tempPath;
						velocity.copyFrom(_tempVelocity);
					}
				}
				else if (Math.floor(_stopTimer * 100) % 2 == 0)
					shoot();
			}
		}
		
		private function shoot():void
		{
			var bulletX:Number = x + (width / 2);
			var bulletY:Number = y + height;
			Bullet.getNewEnemyBullet(bulletX, bulletY, BULLET_VELOCITY, 10);
			Bullet.getNewEnemyBullet(bulletX, bulletY, BULLET_VELOCITY, -10);
		}
	}

}
package enemies 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Gunner extends Enemy 
	{
		[Embed(source = "../assets/images/gunner.png")] private var sprite:Class
		
		private static const PATH:Vector.<FlxPoint> = Utils.stringToPath("60,25; 260,25; 115,25; 115,240");
		private static const HEALTH:int = 10;
		private static const SPEED:Number = 100;
		private static const STOP_TIME:Number = 2.5;
		private static const BULLET_VELOCITY:FlxPoint = new FlxPoint(50, 200);
		private static const BULLET_COLOR:uint = 0xFF732626;
		private static const EXPLOSION_COLORS:Array = [0xFF732626, 0xFFDF1F20, 0xFF3B2B2B, 0xFFDF207C];
		
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
			super(x, y, HEALTH, PATH, STOP, SPEED, sprite);
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
		
		protected override function get explosionColors():Array
		{
			return EXPLOSION_COLORS;
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
			var bulletY:Number = y + height - 4;
			Bullet.getNewEnemyBullet(bulletX, bulletY, BULLET_VELOCITY, 10, BULLET_COLOR);
			Bullet.getNewEnemyBullet(bulletX, bulletY, BULLET_VELOCITY, -10, BULLET_COLOR);
		}
	}

}
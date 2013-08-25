package enemies 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Gunner extends Enemy 
	{
		[Embed(source = "../assets/images/gunner_1.png")] private static var sprite1:Class
		[Embed(source = "../assets/images/gunner_2.png")] private static var sprite2:Class
		
		private static const LEFT_START_PATH:Vector.<FlxPoint> = Utils.stringToPath("60,25; 260,25; 160,25; 160,270");
		private static const RIGHT_START_PATH:Vector.<FlxPoint> = Utils.stringToPath("260,25; 60,25; 160,25; 160,270");
		private static const HEALTH:int = 15;
		private static const SPEED:Number = 100;
		private static const STOP_TIME:Number = 2.5;
		private static const SINE_BULLET_VELOCITY:FlxPoint = new FlxPoint(50, 200);
		private static const SPREAD_BULLET_SPEED:Number = 600;
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
		private var _isSineShooter:Boolean;
		
		public function Gunner(x:Number, y:Number) 
		{
			super(x, y, HEALTH, getStartPath(x), STOP, SPEED, null);
			resetGunner(x, y, true);
			_tempVelocity = new FlxPoint;
		}
		
		public function resetGunner(x:Number, y:Number, calledFromConstructor:Boolean = false):void
		{
			if (!calledFromConstructor)
				super.resetEnemy(x, y, HEALTH, getStartPath(x), STOP, SPEED);
			
			var sprite:Class = chooseSprite();
			loadGraphic(sprite);
			_isSineShooter = sprite == sprite1;
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
			if (_isSineShooter)
				sineShoot();
			else
				spreadShoot();
		}
		
		private function sineShoot():void
		{
			var halfBulletSize:Number = Bullet.BULLET_SIZE / 2;
			var bulletX:Number = x + (width / 2) - halfBulletSize;
			var bulletY:Number = y + height - Bullet.BULLET_SIZE;
			Bullet.getNewEnemyBullet(bulletX, bulletY, SINE_BULLET_VELOCITY, 10, BULLET_COLOR);
			Bullet.getNewEnemyBullet(bulletX, bulletY, SINE_BULLET_VELOCITY, -10, BULLET_COLOR);
		}
		
		private function spreadShoot():void
		{
			var halfBulletSize:Number = Bullet.BULLET_SIZE / 2;
			Bullet.getNewEnemyBullet(x + (width / 2) - halfBulletSize, y + height - Bullet.BULLET_SIZE, new FlxPoint(0, SPREAD_BULLET_SPEED), 0, BULLET_COLOR);
			var bulletVelocity:FlxPoint = new FlxPoint(-1.414 * SPREAD_BULLET_SPEED, 1.414 * SPREAD_BULLET_SPEED);
			Bullet.getNewEnemyBullet(x + (width / 2) - 12, y + height - 12, bulletVelocity, 0, BULLET_COLOR);
			bulletVelocity.x = -bulletVelocity.x;
			Bullet.getNewEnemyBullet(x + (width / 2) + 12, y + height - 12, bulletVelocity, 0, BULLET_COLOR);
		}
		
		private function getStartPath(x:Number):Vector.<FlxPoint>
		{
			return x < FlxG.width / 2 ? LEFT_START_PATH : RIGHT_START_PATH
		}
		
		private function chooseSprite():Class
		{
			return Math.random() < 0.5 ? sprite1 : sprite2;
		}
	}

}
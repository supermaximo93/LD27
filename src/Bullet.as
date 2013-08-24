package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Bullet extends FlxSprite 
	{		
		private static var _playerBullets:FlxGroup = new FlxGroup;
		private static var _enemyBullets:FlxGroup = new FlxGroup;
		
		public static function get playerBullets():FlxGroup
		{
			return _playerBullets;
		}
		
		public static function get enemyBullets():FlxGroup
		{
			return _enemyBullets;
		}
		
		public static function getNewPlayerBullet(x:Number, y:Number, velocity:FlxPoint, sineSpeed:Number):Bullet
		{
			return getNewBullet(x, y, velocity, sineSpeed, _playerBullets);
		}
		
		public static function getNewEnemyBullet(x:Number, y:Number, velocity:FlxPoint, sineSpeed:Number):Bullet
		{
			return getNewBullet(x, y, velocity, sineSpeed, _enemyBullets);
		}
		
		private static function getNewBullet(x:Number, y:Number, velocity:FlxPoint, sineSpeed:Number, group:FlxGroup):Bullet
		{
			var bullet:Bullet = group.getFirstAvailable(Bullet) as Bullet;
			if (bullet == null)
			{
				bullet = new Bullet(x, y, velocity, sineSpeed);
				group.add(bullet);
			}
			else
				bullet.resetBullet(x, y, velocity, sineSpeed);
			return bullet;
		}
		
		private var _isPlayerBullet:Boolean;
		private var _sineSpeed:Number;
		private var _sineTimer:Number;
		private var _originalX:Number;
		
		public function get isPlayerBullet():Boolean
		{
			return _isPlayerBullet;
		}
		
		public function Bullet(x:Number, y:Number, velocity:FlxPoint, sineSpeed:Number)
		{
			super(x, y);
			makeGraphic(10, 10);
			resetBullet(x, y, velocity, sineSpeed);
		}
		
		public function resetBullet(x:Number, y:Number, velocity:FlxPoint, sineSpeed:Number):void
		{
			super.reset(x, y);
			this.velocity.copyFrom(velocity);
			maxVelocity.x = Math.abs(velocity.x);
			maxVelocity.y = Math.abs(velocity.y);
			_sineSpeed = sineSpeed;
			_sineTimer = 0;
			if (_sineSpeed != 0)
			{
				_originalX = x;
				this.velocity.x = 0;
			}
		}
		
		public override function update():void
		{
			if (_sineSpeed != 0)
				updateSineMovement();
			killIfOffScreen();
			super.update();
		}
		
		private function updateSineMovement():void
		{
			_sineTimer += FlxG.elapsed * _sineSpeed;
			x = _originalX + (Math.sin(_sineTimer) * maxVelocity.x);
		}
		
		private function killIfOffScreen():void
		{
			if (y + height < 0 || y - height > FlxG.height)
				kill();
		}
	}

}
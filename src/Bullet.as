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
		
		public static function getNewPlayerBullet(x:Number, y:Number, velocity:FlxPoint):Bullet
		{
			return getNewBullet(x, y, velocity, _playerBullets);
		}
		
		public static function getNewEnemyBullet(x:Number, y:Number, velocity:FlxPoint):Bullet
		{
			return getNewBullet(x, y, velocity, _enemyBullets);
		}
		
		private static function getNewBullet(x:Number, y:Number, velocity:FlxPoint, group:FlxGroup):Bullet
		{
			var bullet:Bullet = group.getFirstAvailable(Bullet) as Bullet;
			if (bullet == null)
			{
				bullet = new Bullet(x, y, velocity);
				group.add(bullet);
			}
			else
				bullet.resetBullet(x, y, velocity);
			return bullet;
		}
		
		private var _isPlayerBullet:Boolean;
		
		public function get isPlayerBullet():Boolean
		{
			return _isPlayerBullet;
		}
		
		public function Bullet(x:Number, y:Number, velocity:FlxPoint)
		{
			super(x, y);
			makeGraphic(10, 10);
			resetBullet(x, y, velocity);
		}
		
		public function resetBullet(x:Number, y:Number, velocity:FlxPoint):void
		{
			super.reset(x, y);
			this.velocity = velocity;
		}
	}

}
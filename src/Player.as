package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Player extends FlxSprite 
	{
		private const ACCELERATION:Number = 3000;
		private const MAX_VELOCITY:Number = 600;
		private const DRAG:Number = 3000;
		private const SHOOT_TIME:Number = 0.1;
		
		private var previousAcceleration:FlxPoint;
		private var shootTimer:Number;
		
		public function Player(x:Number, y:Number) 
		{
			super(x, y, null);
			makeGraphic(32, 32, 0xff0000ff);
			origin = new FlxPoint(16, 16);
			maxVelocity.x = MAX_VELOCITY;
			maxVelocity.y = MAX_VELOCITY;
			drag.x = DRAG;
			drag.y = DRAG;
			previousAcceleration = new FlxPoint();
			shootTimer = 0;
		}
		
		public function move(xDirection:int, yDirection:int):void
		{
			acceleration.copyTo(previousAcceleration);
			var directionVector:FlxPoint = new FlxPoint(xDirection, yDirection);
			acceleration.x = directionVector.x * ACCELERATION;
			acceleration.y = directionVector.y * ACCELERATION;
			if ((acceleration.x != 0 || previousAcceleration.x != 0) && previousAcceleration.x == -acceleration.x || (acceleration.x != 0 && velocity.x != 0 && acceleration.x / Math.abs(acceleration.x) != velocity.x / Math.abs(velocity.x)))
				velocity.x /= 50.0;
			if ((acceleration.y != 0 || previousAcceleration.y != 0) && previousAcceleration.y == -acceleration.y || (acceleration.y != 0 && velocity.y != 0 && acceleration.y / Math.abs(acceleration.y) != velocity.y / Math.abs(velocity.y)))
				velocity.y /= 50.0;
		}
		
		public function shoot():void
		{
			if (shootTimer >= SHOOT_TIME)
			{
				Bullet.getNewEnemyBullet(x, y, new FlxPoint(0, -1000));
				shootTimer = 0;
			}
		}
		
		override public function update():void 
		{
			shootTimer += FlxG.elapsed;
			super.update();
		}
	}

}
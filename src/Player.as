package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Player extends FlxSprite 
	{
		[Embed(source = "assets/images/player.png")] private var sprite:Class
		
		public static function bulletCollision(obj1:FlxObject, obj2:FlxObject):void
		{
			obj1.kill()
			obj2.kill();
		}
		
		private const ACCELERATION:Number = 1500;
		private const MAX_VELOCITY:Number = 300;
		private const DRAG:Number = 1500;
		private const SHOOT_TIME:Number = 0.05;
		private const HITBOX_SCALE_X:Number = 0.2;
		private const HITBOX_SCALE_Y:Number = 0.2;
		
		private var _previousAcceleration:FlxPoint;
		private var _shootTimer:Number;
		private var _originalWidth:Number;
		private var _originalHeight:Number;
		
		public function Player(x:Number, y:Number) 
		{
			super(x, y, sprite);
			maxVelocity.x = MAX_VELOCITY;
			maxVelocity.y = MAX_VELOCITY;
			drag.x = DRAG;
			drag.y = DRAG;
			_previousAcceleration = new FlxPoint();
			_shootTimer = 0;
			_originalWidth = width;
			_originalHeight = height;
			width *= HITBOX_SCALE_X;
			height *= HITBOX_SCALE_Y;
			centerOffsets();
		}
		
		public function move(xDirection:int, yDirection:int):void
		{
			acceleration.copyTo(_previousAcceleration);
			var directionVector:FlxPoint = new FlxPoint(xDirection, yDirection);
			acceleration.x = directionVector.x * ACCELERATION;
			acceleration.y = directionVector.y * ACCELERATION;
			if ((acceleration.x != 0 || _previousAcceleration.x != 0) && _previousAcceleration.x == -acceleration.x || (acceleration.x != 0 && velocity.x != 0 && acceleration.x / Math.abs(acceleration.x) != velocity.x / Math.abs(velocity.x)))
				velocity.x /= 50.0;
			if ((acceleration.y != 0 || _previousAcceleration.y != 0) && _previousAcceleration.y == -acceleration.y || (acceleration.y != 0 && velocity.y != 0 && acceleration.y / Math.abs(acceleration.y) != velocity.y / Math.abs(velocity.y)))
				velocity.y /= 50.0;
		}
		
		public function shoot():void
		{
			if (_shootTimer >= SHOOT_TIME)
			{
				Bullet.getNewPlayerBullet(x + (width / 2.0), y, new FlxPoint(0, -1000), 0, 0xFF349933);
				_shootTimer = 0;
			}
		}
		
		public override function update():void 
		{
			_shootTimer += FlxG.elapsed;
			
			var potentialX:Number = x + (velocity.x * FlxG.elapsed);
			var potentialY:Number = y + (velocity.y * FlxG.elapsed);
			var leftBorder:Number = (-_originalWidth / 2) + offset.x;
			var rightBorder:Number = FlxG.width + leftBorder;
			var topBorder:Number = (-_originalHeight / 2) + offset.y;
			var bottomBorder:Number = FlxG.height + topBorder;
			if (potentialX < leftBorder)
				velocity.x = (leftBorder - x) / FlxG.elapsed;
			else if (potentialX > rightBorder)
				velocity.x = (rightBorder - x) / FlxG.elapsed;
			if (potentialY < topBorder)
				velocity.y = (topBorder - y) / FlxG.elapsed;
			else if (potentialY > bottomBorder)
				velocity.y = (bottomBorder - y) / FlxG.elapsed;
			
			super.update();
		}
	}

}
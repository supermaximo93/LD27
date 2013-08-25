package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Player extends FlxSprite 
	{
		[Embed(source = "assets/sounds/respawn.mp3")] public static var respawnSound:Class
		[Embed(source = "assets/sounds/shoot.mp3")] private static var shootSound:Class
		[Embed(source = "assets/sounds/uninvincible.mp3")] private static var uninvincibleSound:Class
		[Embed(source = "assets/images/player.png")] private static var sprite:Class
		
		private static const ACCELERATION:Number = 1500;
		private static const MAX_VELOCITY:Number = 300;
		private static const DRAG:Number = 1500;
		private static const SHOOT_TIME:Number = 0.05;
		private static const HITBOX_SCALE_X:Number = 0.1;
		private static const HITBOX_SCALE_Y:Number = 0.1;
		private static const EXPLOSION_COLORS:Array = [0xFF349933, 0xFF386237, 0xFF00FF01, 0xFF7EDF20];
		private static const INVINCIBILITY_TIME:Number = 1.5;
		
		public static function bulletCollision(obj1:FlxObject, obj2:FlxObject):void
		{
			var bullet:FlxObject;
			var player:Player = obj1 as Player;
			if (obj1 == null)
			{
				player = obj2 as Player;
				bullet = obj1;
			}
			else
				bullet = obj2;
			player.enemyKill();
			bullet.kill();
		}
		
		private var _previousAcceleration:FlxPoint;
		private var _shootTimer:Number;
		private var _originalWidth:Number;
		private var _originalHeight:Number;
		private var _invincibilityTimer:Number;
		
		public function get isInvincible():Boolean
		{
			return _invincibilityTimer > 0;
		}
		
		public function Player(x:Number, y:Number) 
		{
			super(x, y, sprite);
			_originalWidth = width;
			_originalHeight = height;
			width *= HITBOX_SCALE_X;
			height *= HITBOX_SCALE_Y;
			centerOffsets();
			maxVelocity.x = MAX_VELOCITY;
			maxVelocity.y = MAX_VELOCITY;
			drag.x = DRAG;
			drag.y = DRAG;
			_previousAcceleration = new FlxPoint();
			reset(x, y);
			_invincibilityTimer = 0;
		}
		
		public override function reset(x:Number, y:Number):void
		{
			super.reset(x, y);
			_shootTimer = 0;
			_invincibilityTimer = INVINCIBILITY_TIME;
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
				Bullet.getNewPlayerBullet(x + (width / 2.0) - (Bullet.BULLET_SIZE / 2), y, new FlxPoint(0, -1000), 0, 0xFF349933);
				FlxG.play(shootSound);
				_shootTimer = 0;
			}
		}
		
		public override function update():void 
		{
			_shootTimer += FlxG.elapsed;
			updateVelocity();
			updateInvincibility();
			super.update();
		}
		
		public function enemyKill():void
		{
			if (!isInvincible)
			{
				Utils.createExplosion(x + (width / 2) + offset.x, y + (height / 2) + offset.y, EXPLOSION_COLORS);
				PlayState.startPlayerRespawnTimer();
				kill();
			}
		}
		
		private function updateVelocity():void
		{
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
		}
		
		private function updateInvincibility():void
		{
			if (_invincibilityTimer > 0)
			{
				_invincibilityTimer -= FlxG.elapsed;
				if (_invincibilityTimer <= 0)
				{
					visible = true;
					FlxG.play(uninvincibleSound, 1.4);
				}
				else
					visible = Math.floor(_invincibilityTimer * 100) % 2 == 0;
			}
		}
	}

}
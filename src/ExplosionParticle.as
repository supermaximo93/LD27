package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class ExplosionParticle extends FlxSprite 
	{
		private static const MIN_SPEED:Number = 200;
		private static const MAX_SPEED:Number = 600;
		private static const MIN_SIZE:Number = 4;
		private static const MAX_SIZE:Number = 8;
		private static const LIFETIME:Number = 0.7;
		private static const DRAG:Number = 2000;
		private static const DRAG_TIME:Number = 0.2;
		private static const CONSTANT_Y_SPEED:Number = -400;
		private static const ACCELERATION_Y:Number = -2000;
		
		private static var _explosionParticles:FlxGroup = new FlxGroup;
		
		public static function get explosionParticles():FlxGroup
		{
			return _explosionParticles;
		}
		
		public static function getNewExplosionParticle(x:Number, y:Number, color:uint):ExplosionParticle
		{
			var explosionParticle:ExplosionParticle = _explosionParticles.getFirstAvailable(ExplosionParticle) as ExplosionParticle;
			if (explosionParticle == null)
			{
				explosionParticle = new ExplosionParticle(x, y, color);
				_explosionParticles.add(explosionParticle);
			}
			else
				explosionParticle.resetExplosionParticle(x, y, color);
			return explosionParticle;
		}
		
		private var _lifetime:Number;
		private var _dragTimer:Number;
		
		public function ExplosionParticle(x:Number, y:Number, color:uint) 
		{
			super(0, 0);
			drag.x = DRAG;
			drag.y = DRAG;
			acceleration.y = ACCELERATION_Y;
			resetExplosionParticle(x, y, color);
		}
		
		public function resetExplosionParticle(x:Number, y:Number, color:uint):void
		{
			super.reset(x, y);
			var size:int = int(Math.round(Utils.lerp(MIN_SIZE, MAX_SIZE, Math.random())));
			makeGraphic(size, size, color);
			var directionVector:FlxPoint = Utils.getNormalizedVector(Math.random() - 0.5, (Math.random() - 0.5) / 2);
			var speed:Number = Utils.lerp(MIN_SPEED, MAX_SPEED, Math.random());
			velocity.x = directionVector.x * speed;
			velocity.y = directionVector.y * speed;
			_lifetime = LIFETIME;
			_dragTimer = DRAG_TIME;
		}
		
		public override function update():void
		{
			_lifetime -= FlxG.elapsed;
			if (_lifetime <= 0)
				kill();
			_dragTimer -= FlxG.elapsed;
			if (_dragTimer <= 0)
			{
				drag.y = 0;
				if (velocity.y > 0)
					velocity.y = 0;
			}
		}
		
		/*public override function postUpdate():void
		{
			velocity.y += CONSTANT_Y_SPEED;
			super.postUpdate();
			velocity.y -= CONSTANT_Y_SPEED;
		}*/
	}

}
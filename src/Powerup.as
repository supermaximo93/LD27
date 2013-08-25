package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Powerup extends FlxSprite 
	{
		[Embed(source = "assets/images/powerup.png")] private static var sprite:Class
		
		public static const SPREAD:uint = 0;
		public static const SINE:uint = 1;
		public static const DOUBLE:uint = 2;
		
		private static const POWERUP_TYPE_COUNT:int = 3;
		private static const POWERUP_LIFETIME:Number = 3;
		
		private static var _powerups:FlxGroup = new FlxGroup;
		
		public static function get powerups():FlxGroup
		{
			return _powerups;
		}
		
		public static function getNewPowerup(x:Number, y:Number):Powerup
		{
			var powerup:Powerup = _powerups.getFirstAvailable(Powerup) as Powerup;
			if (powerup == null)
			{
				powerup = new Powerup(x, y);
				_powerups.add(powerup);
			}
			else
				powerup.resetPowerup(x, y);
			return powerup;
		}
		
		private var _powerupType:uint;
		private var _lifetime:Number;
		
		public function get powerupType():uint
		{
			return _powerupType;
		}
		
		public function Powerup(x:Number, y:Number) 
		{
			super(x, y, sprite);
			width *= 2;
			height *= 2;
			centerOffsets();
			resetPowerup(x, y);
		}
		
		public function resetPowerup(x:Number, y:Number):void
		{
			super.reset(x - offset.x - (width / 2), y - offset.y - (height / 2));
			_powerupType = uint(Math.round(Math.random() * (POWERUP_TYPE_COUNT - 1)));
			_lifetime = POWERUP_LIFETIME;
			visible = true;
		}
		
		public override function update():void
		{
			_lifetime -= FlxG.elapsed;
			if (_lifetime <= 0)
				kill();
			else if (_lifetime < POWERUP_LIFETIME / 3)
				visible = Math.floor(_lifetime * 100) % 2 == 0;
		}
	}

}
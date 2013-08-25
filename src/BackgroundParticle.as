package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class BackgroundParticle extends FlxSprite 
	{
		private static const SIZE:int = 2;
		private static const SPEED:Number = 1200;
		private static const COLORS:Array = [0xFFFE71CD, 0xFFFF8C66, 0xFF72FED0, 0xFFBBFFB8, 0xFF626237];
		
		private static var _backgroundParticles:FlxGroup = new FlxGroup;
		
		public static function get backgrounParticles():FlxGroup
		{
			return _backgroundParticles;
		}
		
		public static function getNewBackgroundParticle():BackgroundParticle
		{
			var backgroundParticle:BackgroundParticle = _backgroundParticles.getFirstAvailable as BackgroundParticle;
			if (backgroundParticle == null)
			{
				backgroundParticle = new BackgroundParticle();
				_backgroundParticles.add(backgroundParticle);
			}
			else
				backgroundParticle.resetBackgroundParticle();
			return backgroundParticle;
		}
		
		public function BackgroundParticle() 
		{
			super(0, 0);
			resetBackgroundParticle();
		}
		
		public function resetBackgroundParticle():void
		{
			super.reset(Math.random() * FlxG.width, -SIZE);
			makeGraphic(SIZE, SIZE, COLORS[int(Math.floor(Math.random() * COLORS.length))]);
			velocity.y = SPEED;
		}
		
		public override function update():void
		{
			super.update();
			if (y > FlxG.height)
				kill();
		}
	}

}
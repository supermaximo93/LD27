package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Utils 
	{
		public static function getNormalizedVector(x:Number, y:Number):FlxPoint
		{
			if (x == 0)
			{
				if (y == 0)
					return new FlxPoint();
				return new FlxPoint(0, y / Math.abs(y));
			}
			else if (y == 0)
				return new FlxPoint(x / Math.abs(x), 0);
				
			var length:Number = Math.sqrt((x * x) + (y * y));
			return new FlxPoint(x / length, y / length);
		}
		
		public static function stringToPath(str:String):Vector.<FlxPoint>
		{
			var path:Vector.<FlxPoint> = new Vector.<FlxPoint>;
			var pointStrings:Array = str.split("; ");
			var length:int = pointStrings.length;
			for (var i:int = 0; i < length; ++i)
			{
				var xy:Array = (pointStrings[i] as String).split(",");
				path.push(new FlxPoint(parseFloat(xy[0]), parseFloat(xy[1])));
			}
			return path;
		}
		
		public static function lerp(min:Number, max:Number, x:Number):Number
		{
			return min + ((max - min) * x);
		}
		
		public static function createExplosion(x:Number, y:Number, colors:Array):void
		{
			const PARTICLE_COUNT:int = 10;
			for (var i:int = 0; i < PARTICLE_COUNT; ++i)
				ExplosionParticle.getNewExplosionParticle(x, y, colors[int(Math.floor(Math.random() * colors.length))]);
			FlxG.shake(0.03, 0.2);
		}
	}

}
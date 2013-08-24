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
		
	}

}
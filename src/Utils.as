package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Utils 
	{
		public static function normalize(vector:FlxPoint):FlxPoint
		{
			if (vector.x == 0)
			{
				if (vector.y == 0)
					return new FlxPoint();
				return new FlxPoint(0, vector.y / Math.abs(vector.y));
			}
			else if (vector.y == 0)
				return new FlxPoint(vector.x / Math.abs(vector.x), 0);
				
			var length:Number = Math.sqrt((vector.x * vector.x) + (vector.y * vector.y));
			return new FlxPoint(vector.x / length, vector.y / length);
		}
		
	}

}
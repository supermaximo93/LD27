package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class MenuState extends FlxState
	{
		public override function create():void
		{
			FlxG.bgColor = 0xFFFFB8B3;
		}
		
		public override function update():void
		{
			if (FlxG.keys.SPACE)
				FlxG.switchState(new PlayState);
		}
	}

}
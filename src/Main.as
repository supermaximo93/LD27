package 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	[Frame(factoryClass="Preloader")]
	public class Main extends FlxGame 
	{
		
		public function Main():void 
		{
			super(320, 240, PlayState, 2, 60, 60);
		}
		
	}
	
}
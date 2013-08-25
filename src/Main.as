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
		public static const MENU_MUSIC_ID:int = 0;
		public static const GAME_MUSIC_ID:int = 1;
		
		public function Main():void 
		{
			super(320, 240, MenuState, 2, 60, 60);
		}
		
	}
	
}
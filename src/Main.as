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
		
		private static var _kongregate:Kongregate;
		
		public static function get kongregate():Kongregate
		{
			return _kongregate;
		}
		
		public static function initializeKongregate(onLoadCallback:Function, onLoadErrorCallback:Function):void
		{
			if (_kongregate != null)
				return;
			
			_kongregate = new Kongregate();
			FlxG.stage.addChild(_kongregate);
			_kongregate.initialize(onLoadCallback, function():void {
				if (onLoadCallback != null)
					onLoadErrorCallback.call();
				FlxG.stage.removeChild(_kongregate);
				_kongregate = null;
			});
		}
		
		public function Main():void 
		{
			super(320, 240, MenuState, 2, 60, 60);
		}
		
	}
	
}
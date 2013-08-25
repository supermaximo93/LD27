package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class MenuState extends FlxState
	{
		[Embed(source = "assets/music/menu.mp3")] private static var music:Class
		
		public override function create():void
		{
			FlxG.bgColor = 0xFFFFB8B3;
			FlxG.playMusic(music);
			FlxG.music.ID = Main.MENU_MUSIC_ID;
			add(BackgroundParticle.backgroundParticles);
		}
		
		public override function update():void
		{
			BackgroundParticle.getNewBackgroundParticle();
			if (FlxG.keys.SPACE)
				FlxG.switchState(new PlayState);
			super.update();
		}
	}

}
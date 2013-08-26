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
		[Embed(source = "assets/images/sky_turkeys.png")] private static var skyTurkeysSprite:Class
		[Embed(source = "assets/images/extreme.png")] private static var extremeSprite:Class
		
		private var _startedKongregateConnection:Boolean;
		
		private static const HELP_TEXT:Array = [
			"ARROW KEYS TO MOVE",
			"SPACE TO FIRE",
			"REACH THE GOAL SCORE WITHIN 10 SECONDS",
			"THE GOAL SCORE INCREASES WHEN YOU BEAT IT",
			"BLOW STUFF UP AND DON'T DIE TO BUILD COMBOS",
			"PRESS SPACE TO START"
		]
		
		public override function create():void
		{
			FlxG.bgColor = 0xFFFFB8B3;
			FlxG.playMusic(music);
			FlxG.music.ID = Main.MENU_MUSIC_ID;
			add(BackgroundParticle.backgroundParticles);
			add(new FlxSprite(15, 20, skyTurkeysSprite));
			add(new FlxSprite(125, 60, extremeSprite));
			var text:FlxText;
			for (var i:int = 0; i < HELP_TEXT.length; ++i)
			{
				text = new FlxText(0, 100 + (i * 20), 500, HELP_TEXT[i]);
				Utils.centerAndColorText(text);
				add(text);
			}
			text = new FlxText(2, 224, 100, "BY MAX FOSTER");
			text.color = 0xFF000000;
			add(text);
			text = new FlxText(227, 224, 100, "@SUPERMAXIMO93");
			text.color = 0xFF000000;
			add(text);
			_startedKongregateConnection = false;
		}
		
		public override function update():void
		{
			if (!_startedKongregateConnection && Main.kongregate == null)
			{
				Main.initializeKongregate(null, null);
				_startedKongregateConnection = true;
			}
			
			BackgroundParticle.getNewBackgroundParticle();
			if (FlxG.keys.SPACE)
				FlxG.switchState(new PlayState);
			super.update();
		}
	}

}
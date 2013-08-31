package  
{
	import flash.ui.Mouse;
	import org.flixel.*;
	import com.newgrounds.ScoreBoard;
	import com.newgrounds.components.ScoreBrowser;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class HighScoresState extends FlxState 
	{
		private var _scoreBrowser:ScoreBrowser;
		
		public override function create():void
		{
			FlxG.bgColor = 0xFF000000;
			Mouse.show();
			_scoreBrowser = new ScoreBrowser();
			_scoreBrowser.scoreBoardName = "High Scores";
			_scoreBrowser.period = ScoreBoard.ALL_TIME;
			_scoreBrowser.loadScores();
			FlxG.stage.addChild(_scoreBrowser);
			_scoreBrowser.x = (FlxG.stage.stageWidth - _scoreBrowser.width) / 2;
			_scoreBrowser.y = (FlxG.stage.stageHeight - _scoreBrowser.height) / 2;
			
			var text:FlxText = new FlxText(0, 210, FlxG.width, "PRESS ENTER TO GO BACK");
			text.alignment = "center";
			add(text);
		}
		
		public override function destroy():void
		{
			Mouse.hide();
			FlxG.stage.removeChild(_scoreBrowser);
		}
		
		public override function update():void
		{
			if (FlxG.keys.ENTER)
				FlxG.switchState(new MenuState);
		}
	}

}
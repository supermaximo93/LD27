package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class PlayState extends FlxState 
	{
		
		private var player:Player;
		
		override public function create():void
		{
			player = new Player(100, 100);
			add(player);
		}
		
		override public function update():void
		{
			handleInput();
			super.update();
		}
		
		private function handleInput():void
		{
			var xDirection:int = 0;
			var yDirection:int = 0;
			if (FlxG.keys.pressed("LEFT"))
				--xDirection;
			if (FlxG.keys.pressed("RIGHT"))
				++xDirection;
			if (FlxG.keys.pressed("UP"))
				--yDirection;
			if (FlxG.keys.pressed("DOWN"))
				++yDirection;
			
			player.move(xDirection, yDirection);
		}
	}

}
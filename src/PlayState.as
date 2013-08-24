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
			add(Bullet.playerBullets);
			add(Bullet.enemyBullets);
			player = new Player(100, 100);
			add(player);
			var path:Vector.<FlxPoint> = new Vector.<FlxPoint>;
			path.push(new FlxPoint(10, 10), new FlxPoint(50, 50), new FlxPoint(10, 140), new FlxPoint(300, 200), new FlxPoint(450, 300), new FlxPoint(600, 10));
			add(new Enemy(10, 10, 10, path, 800));
		}
		
		override public function update():void
		{
			handleInput();
			FlxG.collide(player, Bullet.enemyBullets, Player.bulletCollision);
			super.update();
		}
		
		private function handleInput():void
		{
			var xDirection:int = 0;
			var yDirection:int = 0;
			if (FlxG.keys.LEFT)
				--xDirection;
			if (FlxG.keys.RIGHT)
				++xDirection;
			if (FlxG.keys.UP)
				--yDirection;
			if (FlxG.keys.DOWN)
				++yDirection;
			
			player.move(xDirection, yDirection);
			
			if (FlxG.keys.SPACE)
				player.shoot();
		}
	}

}
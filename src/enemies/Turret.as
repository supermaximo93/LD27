package enemies 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Turret extends Enemy 
	{
		[Embed(source = "../assets/images/turret.png")] private static var sprite:Class
		
		private static const HEALTH:int = 6;
		private static const SHOOT_TIME:Number = 1;
		private static const BULLET_SPEED:Number = 350;
		private static const EXPLOSION_COLORS:Array = [0xFF9C33FF, 0xFFC300FF, 0xFF6819B3, 0xFFC78CD9];
		
		private static var _turrets:FlxGroup = new FlxGroup;
		
		public static function get turrets():FlxGroup
		{
			return _turrets;
		}
		
		public static function getNewTurret(x:Number, y:Number):Turret
		{
			var turret:Turret = _turrets.getFirstAvailable(Turret) as Turret;
			if (turret == null)
			{
				turret = new Turret(x, y);
				_turrets.add(turret);
			}
			else
				turret.resetTurret(x, y);
			return turret;
		}
		
		private var shootTimer:Number;
		
		protected override function get explosionColors():Array
		{
			return EXPLOSION_COLORS;
		}
		
		public function Turret(x:Number, y:Number) 
		{
			super(x, y, HEALTH, null, CONTINUE, 0, sprite);
			resetTurret(x, y, true);
		}
		
		public function resetTurret(x:Number, y:Number, calledFromConstructor:Boolean = false):void
		{
			if (!calledFromConstructor)
				resetEnemy(x, y, HEALTH, null, CONTINUE, 0);
			shootTimer = 0;
		}
		
		public override function update():void 
		{
			shootTimer += FlxG.elapsed;
			if (shootTimer >= SHOOT_TIME)
			{
				shootTimer = 0;
				shoot();
			}
			
			super.update();
		}
		
		private function shoot():void
		{		
			var bulletX:Number = x + (width / 2) - (Bullet.BULLET_SIZE / 2);
			var bulletY:Number = y + height - (Bullet.BULLET_SIZE / 2);
			Bullet.getNewEnemyBullet(bulletX, bulletY, new FlxPoint(0, BULLET_SPEED), 0, 0xFF9C33FF);
		}
	}

}
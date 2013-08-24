package enemies 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Turret extends Enemy 
	{
		private const HEALTH:int = 6;
		private const SHOOT_TIME:Number = 1;
		private const BULLET_SPEED:Number = 700;
		
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
		
		public function Turret(x:Number, y:Number) 
		{
			super(x, y, HEALTH, null, 0);
			resetTurret(x, y, true);
		}
		
		public function resetTurret(x:Number, y:Number, calledFromConstructor:Boolean = false):void
		{
			if (calledFromConstructor)
				resetEnemy(x, y, HEALTH, null, 0);
			shootTimer = 0;
		}
		
		override public function update():void 
		{
			shootTimer += FlxG.elapsed;
			if (shootTimer >= SHOOT_TIME)
			{
				shootTimer = 0;
				Bullet.getNewEnemyBullet(x + (width / 2), y + (height / 2), new FlxPoint(0, BULLET_SPEED));
			}
			
			super.update();
		}
	}

}
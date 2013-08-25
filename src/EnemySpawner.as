package  
{
	import enemies.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class EnemySpawner 
	{
		private static const MAX_FIGHTERS:int = 5;
		private static const MAX_GUNNERS:int = 1;
		private static const MAX_TURRETS:int = 3;
		private static const FIGHER_CHECK_TIME:Number = 1;
		private static const GUNNER_CHECK_TIME:Number = 7;
		private static const TURRET_CHECK_TIME:Number = 3;
		
		private var _fighterCheckTimer:Number;
		private var _gunnerCheckTimer:Number;
		private var _turretCheckTimer:Number;
		private var _continueUpdating:Boolean;
		
		public function EnemySpawner() 
		{
			_fighterCheckTimer = FIGHER_CHECK_TIME * Math.random();
			_gunnerCheckTimer = GUNNER_CHECK_TIME * Math.random();
			_turretCheckTimer = TURRET_CHECK_TIME * Math.random();
			_continueUpdating = false;
		}
		
		public function update():void
		{
			if (!_continueUpdating)
				return;
			
			updateTimers();
			checkAndSpawnEnemies();
		}
		
		public function start():void
		{
			_continueUpdating = true;
		}
		
		public function pause():void
		{
			_continueUpdating = false;
		}
		
		private function updateTimers():void
		{
			_fighterCheckTimer += FlxG.elapsed;
			_gunnerCheckTimer += FlxG.elapsed;
			_turretCheckTimer += FlxG.elapsed;
		}
		
		private function checkAndSpawnEnemies():void
		{
			checkAndSpawnFighters();
			checkAndSpawnGunners();
			checkAndSpawnTurrets();
		}
		
		private function checkAndSpawnFighters():void
		{
			if (_fighterCheckTimer >= FIGHER_CHECK_TIME)
			{
				_fighterCheckTimer = 0;
				if (Fighter.fighters.countLiving() < MAX_FIGHTERS)
					Fighter.getNewFighter(0, 0);
			}
		}
		
		private function checkAndSpawnGunners():void
		{
			if (_gunnerCheckTimer >= GUNNER_CHECK_TIME)
			{
				_gunnerCheckTimer = 0;
				if (Gunner.gunners.countLiving() < MAX_GUNNERS)
					Gunner.getNewGunner(Math.random() < 0.5 ? -40 : FlxG.width + 40, 0);
			}
		}
		
		private function checkAndSpawnTurrets():void
		{
			if (_turretCheckTimer >= TURRET_CHECK_TIME)
			{
				_turretCheckTimer = 0;
				if (Turret.turrets.countLiving() < MAX_TURRETS)
					Turret.getNewTurret(Utils.lerp(30, FlxG.width - 30, Math.random()), -30);
			}
		}
	}

}
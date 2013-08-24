package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Enemy extends FlxSprite 
	{
		public static const DOWNWARDS_SPEED:Number = 100;
		
		private const POINT_TOLERANCE:Number = 5;
		private const HEALTH_MULTIPLIER_FOR_SCORE:int = 10;
		private const SCREEN_BORDER:Number = 100;
		
		public static function bulletCollision(obj1:FlxObject, obj2:FlxObject):void
		{
			var bullet:Bullet;
			var enemy:Enemy = obj1 as Enemy;
			if (enemy == null)
			{
				enemy = obj2 as Enemy;
				bullet = obj1 as Bullet;
			}
			else
				bullet = obj2 as Bullet;
			enemy.takeDamage();
			bullet.kill();
		}
		
		private var _maxHealth:int;
		private var _path:Vector.<FlxPoint>;
		private var _nextPathPoint:int;
		private var _speed:Number;
		
		public function Enemy(x:Number, y:Number, health:int, path:Vector.<FlxPoint>, speed:Number) 
		{
			super(x, y);
			makeGraphic(40, 40);
			resetEnemy(x, y, health, path, speed);
		}
		
		public function resetEnemy(x:Number, y:Number, health:int, path:Vector.<FlxPoint>, speed:Number):void
		{
			super.reset(x, y);
			_maxHealth = health;
			this.health = health;
			_nextPathPoint = -1;
			if (path == null)
			{
				_path = null;
				velocity.y = DOWNWARDS_SPEED;
			}
			else
			{
				_path = mapPathToCurrentWorldPosition(path);
				getNextPathPoint();
			}
			_speed = speed;
		}
		
		public function takeDamage():void
		{
			if (--health <= 0)
				playerKill();
		}
		
		public override function update():void 
		{			
			velocity.y -= DOWNWARDS_SPEED;
			
			if (_path != null)
			{
				var nextPoint:FlxPoint = _path[_nextPathPoint];
				var pointDistanceX:Number = nextPoint.x - x;
				var pointDistanceY:Number = nextPoint.y - y;
				var potentialX:Number = x + (velocity.x * FlxG.elapsed);
				var potentialY:Number = y + (velocity.y * FlxG.elapsed);
				var potentialPointDistanceX:Number = nextPoint.x - potentialX;
				var potentialPointDistanceY:Number = nextPoint.y - potentialY;
				
				if ((pointDistanceX > 0 && potentialPointDistanceX < 0) || (pointDistanceX < 0 && potentialPointDistanceX > 0))
					velocity.x = pointDistanceX / FlxG.elapsed;
				if ((pointDistanceY > 0 && potentialPointDistanceY < 0) || (pointDistanceY < 0 && potentialPointDistanceY > 0))
					velocity.y = pointDistanceY / FlxG.elapsed;
				
				super.update();
				
				if (Math.abs(nextPoint.x - x) < POINT_TOLERANCE && Math.abs(nextPoint.y - y) < POINT_TOLERANCE)
				{
					x = nextPoint.x;
					y = nextPoint.y;
					getNextPathPoint();
				}
				movePathWithDownwardsSpeed();
			}
			else
				super.update();
			
			velocity.y += DOWNWARDS_SPEED;
		}
		
		private function playerKill():void
		{
			FlxG.score += _maxHealth * HEALTH_MULTIPLIER_FOR_SCORE;
			kill();
		}
		
		private function getNextPathPoint():void
		{
			if (++_nextPathPoint >= _path.length)
				_nextPathPoint = 0;
			
			var directionVector:FlxPoint = Utils.getNormalizedVector(_path[_nextPathPoint].x - x, _path[_nextPathPoint].y - y);
			velocity.x = directionVector.x * _speed;
			velocity.y = directionVector.y * _speed;
		}

		private function mapPathToCurrentWorldPosition(path:Vector.<FlxPoint>):Vector.<FlxPoint>
		{
			var length:int = path.length;
			var newPath:Vector.<FlxPoint> = new Vector.<FlxPoint>(length, true);
			for (var i:int = 0; i < length; ++i)
				newPath[i] = new FlxPoint(path[i].x - x, path[i].y - y);
			return newPath;
		}
		
		private function movePathWithDownwardsSpeed():void
		{
			var distance:Number = DOWNWARDS_SPEED * FlxG.elapsed;
			var offScreen:Boolean = true;
			var length:int = _path.length;
			for (var i:int = 0; i < length; ++i)
			{
				_path[i].y += distance;
				if (_path[i].y < FlxG.height + SCREEN_BORDER)
					offScreen = false;
			}
			if (offScreen)
				kill();
		}
	}

}
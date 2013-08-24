package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Enemy extends FlxSprite 
	{
		private const POINT_TOLERANCE:Number = 5;
		
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
		
		private var _health:int;
		private var _path:Vector.<FlxPoint>;
		private var _nextPathPoint:int;
		private var _speed:Number;
		
		public function Enemy(x:Number, y:Number, health:int, path:Vector.<FlxPoint>, speed:Number) 
		{
			super(x, y);
			makeGraphic(40, 40);
			_health = health;
			_path = path;
			_nextPathPoint = -1;
			_speed = speed;
			getNextPathPoint();
		}
		
		override public function update():void 
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
		}
		
		private function takeDamage():void
		{
			if (--health <= 0)
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

	}

}
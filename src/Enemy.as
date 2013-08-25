package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Enemy extends FlxSprite 
	{
		protected static const CONTINUE:uint = 0;
		protected static const REVERSE:uint = 1;
		protected static const STOP:uint = 2;
		
		private static const DOWNWARDS_SPEED:Number = 20;
		private static const POINT_TOLERANCE:Number = 5;
		private static const HEALTH_MULTIPLIER_FOR_SCORE:int = 10;
		private static const SCREEN_BORDER:Number = 10;
		private static const POWERUP_SPAWN_CHANCE:Number = 0.1;
		private static const SCORE_TEXT_TIME:Number = 0.3;		
		private static var _scoreTexts:FlxGroup;
		
		public static function get scoreTexts():FlxGroup
		{
			if (_scoreTexts == null || _scoreTexts.members == null)
				_scoreTexts = new FlxGroup;
			return _scoreTexts;
		}
		
		public static function getNewScoreText(x:Number, y:Number, score:int):FlxText
		{
			var text:FlxText = _scoreTexts.getFirstAvailable(FlxText) as FlxText;
			if (text == null)
			{
				text = new FlxText(x, y, 40);
				text.color = 0xFF000000;
				_scoreTexts.add(text);
			}
			else
				text.reset(x, y);
			text.text = score.toString();
			text.mass = SCORE_TEXT_TIME; // using mass as a timer
			return text;
		}
		
		public static function updateScoreText():void
		{
			var text:FlxText;
			var length:int = _scoreTexts.members.length;
			for (var i:int = 0; i < length; ++i)
			{
				text = _scoreTexts.members[i];
				if (text != null && text.alive)
				{
					text.mass -= FlxG.elapsed;
					if (text.mass <= 0)
						text.kill();
				}
			}
		}
		
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
		
		protected var _path:Vector.<FlxPoint>;
		protected var _nextPathPoint:int;
		protected var _moveDown:Boolean;
		private var _maxHealth:int;
		private var _onPathComplete:uint;
		private var _incNextPathPoint:Boolean;
		private var _speed:Number;
		
		protected function get explosionColors():Array
		{
			return [];
		}
		
		public function Enemy(x:Number, y:Number, health:int, path:Vector.<FlxPoint>, onPathComplete:uint, speed:Number, graphic:Class) 
		{
			super(x, y, graphic);
			resetEnemy(x, y, health, path, onPathComplete, speed);
		}
		
		public function resetEnemy(x:Number, y:Number, health:int, path:Vector.<FlxPoint>, onPathComplete:uint, speed:Number):void
		{
			super.reset(x, y);
			_maxHealth = health;
			this.health = health;
			_speed = speed;
			_moveDown = true;
			_onPathComplete = onPathComplete;
			_nextPathPoint = -1;
			_incNextPathPoint = true;
			if (path == null)
			{
				_path = null;
				velocity.y = DOWNWARDS_SPEED;
			}
			else
			{
				_path = copyPath(path);
				getNextPathPoint();
			}
		}
		
		public function takeDamage():void
		{
			if (--health <= 0)
				playerKill();
		}
		
		public override function update():void 
		{
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
					onPathPointReached();
				}
				if (_moveDown)
					movePathWithDownwardsSpeed();
			}
			else
			{
				super.update();
				killIfOffScreen();
			}
		}
		
		public override function postUpdate():void 
		{
			if (_moveDown)
			{
				velocity.y += DOWNWARDS_SPEED;
				super.postUpdate();
				velocity.y -= DOWNWARDS_SPEED;
			}
			else
				super.postUpdate();
		}
		
		protected function onPathPointReached():void
		{
		}
		
		private function playerKill():void
		{
			var centerX:Number = x + (width / 2);
			var centerY:Number = y + (height / 2)
			var score:int = _maxHealth * HEALTH_MULTIPLIER_FOR_SCORE;
			PlayState.addToScore(score);
			getNewScoreText(centerX, centerY, score);
			Utils.createExplosion(centerX, centerY, explosionColors);
			if (Math.random() <= POWERUP_SPAWN_CHANCE)
				Powerup.getNewPowerup(centerX, centerY);
			kill();
		}
		
		private function getNextPathPoint():void
		{			
			if (_incNextPathPoint)
				++_nextPathPoint;
			else
				--_nextPathPoint;
			
			if (_nextPathPoint >= _path.length)
			{
				if (_onPathComplete == REVERSE)
				{
					_incNextPathPoint = !_incNextPathPoint;
					_nextPathPoint = _path.length - 1;
				}
				else if (_onPathComplete == STOP)
					_path = null;
				else
					_nextPathPoint = 0;
			}
			else if (_nextPathPoint < 0)
			{
				if (_onPathComplete == REVERSE)
				{
					_incNextPathPoint = !_incNextPathPoint;
					_nextPathPoint = 0;
				}
				else if (_onPathComplete == STOP)
					_path = null;
				else
					_nextPathPoint = _path.length - 1;
			}
			
			if (_path == null)
			{
				velocity.x = 0;
				velocity.y = 0;
			}
			else
			{
				var directionVector:FlxPoint = Utils.getNormalizedVector(_path[_nextPathPoint].x - x, _path[_nextPathPoint].y - y);
				velocity.x = directionVector.x * _speed;
				velocity.y = directionVector.y * _speed;
			}
		}
		
		private function copyPath(path:Vector.<FlxPoint>):Vector.<FlxPoint>
		{
			var length:int = path.length;
			var newPath:Vector.<FlxPoint> = new Vector.<FlxPoint>(length, true);
			var halfWidth:Number = width / 2;
			var halfHeight:Number = height / 2;
			for (var i:int = 0; i < length; ++i)
				newPath[i] = new FlxPoint(path[i].x - halfWidth, path[i].y - halfHeight);
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
		
		private function killIfOffScreen():void
		{
			if (y > FlxG.height + SCREEN_BORDER)
				kill();
		}
	}

}
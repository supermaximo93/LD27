package  
{
	import enemies.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class PlayState extends FlxState 
	{
		[Embed(source = "assets/music/game.mp3")] private static var music:Class
		[Embed(source = "assets/sounds/levelup.mp3")] private static var levelUpSound:Class
		
		public static const MUSIC_VOLUME:Number = 1;
		public static const SOUND_VOLUME:Number = 0.4;
		private static const POINTS_PER_LEVEL:int = 1000;
		private static const BACKGROUND_PARTICLE_TIME:Number = 0.001;
		private static const PLAYER_RESPAWN_TIME:Number = 0.5;
		private static const PLAYER_START_X:Number = 160;
		private static const PLAYER_START_Y:Number = 200;
		
		private static var _instance:PlayState;
		
		public static function get player():Player
		{
			return _instance == null ? null : _instance._player;
		}
		
		public static function startPlayerRespawnTimer():void
		{
			_instance._playerRespawnTimer.start(PLAYER_RESPAWN_TIME, 1, _instance.respawnPlayer);
			_instance.breakCombo();
		}
		
		public static function addToScore(points:int):void
		{
			FlxG.score += points;
			_instance._scoreSinceComboBroken += points;
			++_instance._combo;
		}
		
		private var _player:Player;
		private var _enemies:FlxGroup;
		private var _levelCounter:int;
		private var _pointTarget:int;
		private var _scoreText:FlxText;
		private var _goalText:FlxText;
		private var _timerText:FlxText;
		private var _timer:Number;
		private var _backgroundParticleTimer:Number;
		private var _enemySpawner:EnemySpawner;
		private var _playerRespawnTimer:FlxTimer;
		private var _combo:int;
		private var _scoreSinceComboBroken:int;
		
		public override function create():void
		{
			_instance = this;
			FlxG.bgColor = 0xFFFFB8B3;
			add(BackgroundParticle.backgrounParticles);
			add(Bullet.playerBullets);
			add(Bullet.enemyBullets);
			_enemies = new FlxGroup;
			_enemies.add(Turret.turrets);
			_enemies.add(Fighter.fighters);
			_enemies.add(Gunner.gunners);
			add(_enemies);
			_player = new Player(PLAYER_START_X, PLAYER_START_Y);
			add(_player);
			add(ExplosionParticle.explosionParticles);
			_scoreText = new FlxText(2, 2, 200);
			_scoreText.color = 0xff000000;
			_goalText = new FlxText(2, 12, 200);
			_goalText.color = 0xff000000;
			_timerText = new FlxText(2, 22, 200);
			_timerText.color = 0xff000000;
			_timer = 0;
			add(_goalText);
			add(_scoreText);
			add(_timerText);
			_backgroundParticleTimer = 0;
			_enemySpawner = new EnemySpawner();
			_enemySpawner.start();
			_playerRespawnTimer = new FlxTimer();
			_levelCounter = 0;
			levelUp();
			_combo = 0;
			_scoreSinceComboBroken = 0;
			FlxG.playMusic(music, MUSIC_VOLUME);
		}
		
		public override function destroy():void 
		{
			_instance = null;
			BackgroundParticle.backgrounParticles.clear();
			Bullet.playerBullets.clear();
			Bullet.enemyBullets.clear();
			Turret.turrets.clear();
			Fighter.fighters.clear();
			Gunner.gunners.clear();
			ExplosionParticle.explosionParticles.clear();
			super.destroy();
			FlxG.music.stop();
		}
		
		public override function update():void
		{
			handleInput();
			handleCollisions();
			updateScore();
			updateBackgroundParticles();
			_enemySpawner.update();
			super.update();
		}
		
		private function handleInput():void
		{
			if (!_player.alive)
				return;
			
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
			
			_player.move(xDirection, yDirection);
			
			if (FlxG.keys.SPACE)
				_player.shoot();
		}
		
		private function handleCollisions():void
		{
			FlxG.overlap(_player, Bullet.enemyBullets, Player.bulletCollision);
			FlxG.overlap(_enemies, Bullet.playerBullets, Enemy.bulletCollision);
			FlxG.overlap(_player, _enemies, Player.enemyCollision);
		}
		
		private function updateScore():void
		{
			_timer += FlxG.elapsed;
			if (_timer >= 10)
			{
				_timer = 0;
				breakCombo();
				if (FlxG.score >= _pointTarget)
					levelUp();
				else
					;// end the game
			}
			_timerText.text = "TIME: " + (10 - Math.floor(_timer)).toString();
			_scoreText.text = "SCORE: " + FlxG.score.toString();
			if (_combo > 1)
			{
				_scoreText.text += " + " + _scoreSinceComboBroken.toString();
				if (_combo > 2)
					_scoreText.text += " x " + (_combo - 1).toString();
			}
		}
		
		private function levelUp():void
		{
			_pointTarget = FlxG.score + (POINTS_PER_LEVEL * ++_levelCounter);
			_goalText.text = "GOAL: " + _pointTarget.toString();
			FlxG.play(levelUpSound, SOUND_VOLUME);
		}
		
		private function updateBackgroundParticles():void
		{
			_backgroundParticleTimer += FlxG.elapsed;
			if (_backgroundParticleTimer >= BACKGROUND_PARTICLE_TIME)
			{
				_backgroundParticleTimer -= BACKGROUND_PARTICLE_TIME;
				BackgroundParticle.getNewBackgroundParticle();
			}
		}
		
		private function respawnPlayer(timer:FlxTimer):void
		{
			_player.reset(PLAYER_START_X, PLAYER_START_Y);
			FlxG.play(Player.respawnSound);
		}
		
		private function breakCombo():void
		{	
			if (_combo > 0)
				FlxG.score += _scoreSinceComboBroken * (_combo - 1);
			_scoreSinceComboBroken = 0;
			_combo = 0;
		}
	}

}
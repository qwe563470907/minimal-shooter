package;

import flixel.FlxState;
import flixel.FlxG;
import actor.*;
import actor.behavior.*;
import bloc.parser.Parser;

class PlayState extends FlxState
{
	private var _playerArmy:ActorArmy;
	private var _enemyArmy:ActorArmy;

	override public function create():Void
	{
		super.create();

		bgColor = 0xFFFFFFFF;

		Parser.parseYaml(AssetPaths.enemy__yaml);
		var blocPatternDictionary = Parser.patternDictionary;

		var actorAliveMonitoringMediator = new ActorMediator();

		var dieOutOfWorldBehavior = new DieOutOfWorld(200);

		var playerFactory = function()
		{
			var player = new Agent();
			player.setGraphic(AssetPaths.player__png, 360);
			player.drag.x = player.drag.y = 4000;
			player.angularVelocity = 60;
			var userInput = new UserInput();
			player.addBehavior(new ListenInput(userInput));
			player.addBehavior(new ManualMove(userInput, 17, 5));
			player.addBehavior(new ManualShot(userInput));
			player.addBehavior(new RotateByMove(17, 10));

			return player;
		};

		var playerBulletFactory = function()
		{
			var bullet = new Bullet();
			bullet.setGraphic(AssetPaths.playerbullet__png);
			bullet.addBehavior(dieOutOfWorldBehavior);

			return bullet;
		};

		_playerArmy = new ActorArmy(
		  this,
		  actorAliveMonitoringMediator,
		  1,
		  256,
		  playerFactory,
		  playerBulletFactory
		);
		var player = _playerArmy.newAgent();
		player.position.setCartesian(0.5 * FlxG.width, 0.8 * FlxG.height);
		player.syncBlocToFlixel();
		player.setBlocPattern(blocPatternDictionary.get("player"));

		var enemyFactory = function()
		{
			var enemy = new Agent();
			enemy.setGraphic(AssetPaths.enemy__png, 360);
			enemy.angularVelocity = 60;
			enemy.addBehavior(new RotateByMove(17, 10));
			enemy.addBehavior(dieOutOfWorldBehavior);

			return enemy;
		};

		var enemyBulletFactory = function()
		{
			var bullet = new Bullet();
			bullet.setGraphic(AssetPaths.enemybullet__png, 90);
			bullet.addBehavior(dieOutOfWorldBehavior);
			bullet.angularVelocity = 120;

			return bullet;
		};

		_enemyArmy = new ActorArmy(
		  this,
		  actorAliveMonitoringMediator,
		  128,
		  1024,
		  enemyFactory,
		  enemyBulletFactory
		);

		new EnemyGenerator(this, _enemyArmy, blocPatternDictionary);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

import flixel.FlxBasic;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.FlxG;
import actor.ActorArmy;
import bloc.Pattern;

class EnemyGenerator extends FlxBasic
{
	var _random:FlxRandom;
	var _army:ActorArmy;
	var _blocPatternDictionary:Map<String, Pattern>;

	public function new (state:FlxState, Army:ActorArmy, blocPatternDictionary:Map<String, Pattern>)
	{
		super();
		_random = new FlxRandom();
		state.add(this);
		_army = Army;
		_blocPatternDictionary = blocPatternDictionary;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_random.bool(5))
		{
			if (_army.agents.countLiving() >= 1)
				return;

			var newEnemy = _army.newAgent();
			var worldCenterX = 0.5 * FlxG.width;
			newEnemy.position.setCartesian(_random.float(worldCenterX - 200, worldCenterX + 200), -50);
			newEnemy.motionVelocity.setCartesian(0, 50);
			newEnemy.syncBlocToFlixel();
			var action = _blocPatternDictionary.get("enemy2");
			newEnemy.setBlocPattern(action);
		}
	}
}

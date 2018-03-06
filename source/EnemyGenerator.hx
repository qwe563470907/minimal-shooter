import flixel.FlxBasic;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.FlxG;
import actor.ActorArmy;
import action.element.*;

class EnemyGenerator extends FlxBasic
{
	var _random:FlxRandom;
	var _army:ActorArmy;

	public function new(state:FlxState, Army:ActorArmy)
	{
		super();
		_random = new FlxRandom();
		state.add(this);
		_army = Army;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(_random.bool(1))
		{
			if(_army.agents.countLiving() >= 1)
				return;

			var newEnemy = _army.newAgent();
			newEnemy.setCenterPosition(_random.float(100, FlxG.width - 100), -50);
			newEnemy.velocity.set(0, 100);
			var action = new EndlessRepeat(
        new Fire(90, 400),
        120
			);
			newEnemy.actionElement = action;
      newEnemy.actionElement.prepareState(newEnemy.actionStateManager);
		}
	}
}

package actor.behavior;

import flixel.FlxG;

class ManualMove implements Behavior
{
	var userInput: UserInput;
	var highSpeed: Float;
	var lowSpeed: Float;

	public function new (Input: UserInput, HighSpeed: Float, LowSpeed: Float)
	{
		userInput = Input;
		highSpeed = HighSpeed;
		lowSpeed = LowSpeed;
	}

	public function run(actor: ActorSprite): Void
	{
		if (userInput.isMoving)
		{
			actor.motionVelocity.setPolar(
			  userInput.isBraking ? lowSpeed : highSpeed,
			  userInput.movingAngle
			);
		}
		else
		{
			if (userInput.isBraking)
				actor.truncateSpeed(lowSpeed);
		}

		actor.x = Math.min(Math.max(0, actor.x), FlxG.width - actor.width);
		actor.y = Math.min(Math.max(0, actor.y), FlxG.height - actor.height);
	}
}

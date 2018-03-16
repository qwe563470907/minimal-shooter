package actor.behavior;

import flixel.FlxG;
import bloc.DirectionAngle;

class ManualMove implements Behavior
{
	var userInput:UserInput;
	var highSpeed:Float;
	var lowSpeed:Float;

	public function new (Input:UserInput, HighSpeed:Float, LowSpeed:Float)
	{
		userInput = Input;
		highSpeed = HighSpeed;
		lowSpeed = LowSpeed;
	}

	public function run(actor:ActorSprite):Void
	{
		if (userInput.isMoving)
		{
			actor.motionVelocity.setPolar(
			  userInput.isBraking ? lowSpeed:highSpeed,
			  DirectionAngle.fromDegrees(userInput.movingAngle)
			);
		}
		else
		{
			if (userInput.isBraking)
				actor.truncateSpeed(lowSpeed);
		}

		actor.position.x = Math.min(Math.max(actor.halfWidth, actor.position.x), FlxG.width - actor.halfWidth);
		actor.position.y = Math.min(Math.max(actor.halfHeight, actor.position.y), FlxG.height - actor.halfHeight);
	}
}

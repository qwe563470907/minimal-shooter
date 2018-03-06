package actor.behavior;

import flixel.FlxG;

class ManualMove implements IBehavior
{
	var userInput:UserInput;
	var highSpeed:Float;
	var lowSpeed:Float;

  public function new(Input:UserInput, HighSpeed:Float, LowSpeed:Float)
  {
    userInput = Input;
    highSpeed = HighSpeed;
    lowSpeed = LowSpeed;
  }

	public function run(actor:Actor): Void {
		if(userInput.isMoving) {
			actor.setVelocityFromAngle(
			    userInput.movingAngle,
			    userInput.isBraking ? lowSpeed : highSpeed
			);
		} else {
			if(userInput.isBraking)
				actor.truncateSpeed(lowSpeed);

			actor.updateCurrentSpeed();
		}

		actor.x = Math.min(Math.max(0, actor.x), FlxG.width - actor.width);
		actor.y = Math.min(Math.max(0, actor.y), FlxG.height - actor.height);
	}
}

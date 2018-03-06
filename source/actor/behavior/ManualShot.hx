package actor.behavior;

class ManualShot implements IBehavior
{
	var userInput:UserInput;

  public function new(Input:UserInput)
  {
    userInput = Input;
  }

	public function run(actor:Actor): Void {
		if(!userInput.isShooting)
			return;

		if(actor.properFrameCount % 4 > 0)
			return;

		var directionAngle = -90;
		var speed = 3000;
		actor.fire(directionAngle, speed, -30, 0);
		actor.fire(directionAngle, speed, -10, -10);
		actor.fire(directionAngle, speed, 10, -10);
		actor.fire(directionAngle, speed, 30, 0);
	}
}

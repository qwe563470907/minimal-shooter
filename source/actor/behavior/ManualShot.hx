package actor.behavior;

class ManualShot implements Behavior
{
	var userInput:UserInput;

	public function new (Input:UserInput)
	{
		userInput = Input;
	}

	public function run(actor:ActorSprite):Void
	{
		if (!userInput.isShooting)
			return;

		if (actor.properFrameCount % 4 > 0)
			return;

		var directionAngle = -90;
		var speed = 3000;
		actor.shotOffset.setCartesian(-30, 0);
		actor.fire(speed, directionAngle);
		actor.shotOffset.setCartesian(-10, -10);
		actor.fire(speed, directionAngle);
		actor.shotOffset.setCartesian(10, -10);
		actor.fire(speed, directionAngle);
		actor.shotOffset.setCartesian(30, 0);
		actor.fire(speed, directionAngle);
	}
}

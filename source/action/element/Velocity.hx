package action.element;

class Velocity extends PositionalElement
{
	private function new(directionAngle:Float, speed:Float)
	{
		super(speed * Math.cos(directionAngle), speed * Math.sin(directionAngle));
	}
}

class SetVelocity extends Velocity
{
	public function new(directionAngle:Float, speed:Float)
	{
    super(directionAngle, speed);
  }

	override public function run(actor: IActor):Bool
	{
		actor.setVelocity(_x, _y);
		return true;
	}
}

class AddVelocity extends Velocity
{
	public function new(directionAngle:Float, speed:Float)
	{
    super(directionAngle, speed);
  }

	override public function run(actor: IActor):Bool
	{
		actor.addVelocity(_x, _y);
		return true;
	}
}

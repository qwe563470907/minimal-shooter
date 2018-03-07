package action.element;

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

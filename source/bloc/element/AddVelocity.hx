package bloc.element;

class AddVelocity extends Velocity
{
	public function new (directionAngle: Float, speed: Float)
	{
		super(directionAngle, speed);
	}

	override public function run(actor: Actor): Bool
	{
		actor.addVelocity(_x, _y);
		return true;
	}

	override public function toString(): String
	{
		return "add velocity -dir " + this._directionAngle + " -spd " + this._speed;
	}
}

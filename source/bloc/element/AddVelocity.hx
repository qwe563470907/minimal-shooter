package bloc.element;

class AddVelocity extends Velocity
{
	public function new (speed: Float, directionAngle : Float)
	{
		super(speed, directionAngle);
	}

	override public function run(actor: Actor): Bool
	{
		actor.addVelocity(_x, _y);
		return true;
	}

	override public function toString(): String
	{
		return "add velocity -spd " + this._speed + " -dir " + this._directionAngle;
	}
}

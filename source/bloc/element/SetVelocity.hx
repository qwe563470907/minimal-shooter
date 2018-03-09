package bloc.element;

class SetVelocity extends Velocity
{
	public function new (speed: Float, directionAngle : Float)
	{
		super(speed, directionAngle);
	}

	override public function run(actor: Actor): Bool
	{
		actor.setVelocity(_x, _y);
		return true;
	}

	override public function toString(): String
	{
		return "set velocity -spd " + this._speed + " -dir " + this._directionAngle;
	}
}

package bloc.element;

class SetVelocity extends Velocity
{
	public function new (vector:Vector)
	{
		super(vector);
	}

	override public function run(actor:Actor):Bool
	{
		actor.motionVelocity.set(this._vector);

		return true;
	}

	override public function toString():String
	{
		return "set velocity -spd " + this._vector.length + " -dir " + this._vector.angle;
	}
}

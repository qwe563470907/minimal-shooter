package bloc.element;

class AddVelocity extends Velocity
{
	public function new (vector:Vector)
	{
		super(vector);
	}

	override public function run(actor:Actor):Bool
	{
		actor.motionVelocity.add(this._vector);

		return true;
	}

	override public function toString():String
	{
		return "add velocity -spd " + this._vector.length + " -dir " + this._vector.angle;
	}
}

package bloc.element;

import bloc.element.Utility;

class ShotVelocity extends Velocity
{
	public static function create(v1:Float, v2:Float, coords:Coordinates, operation:Operation):ShotVelocity
	{
		var vector = new Vector();

		switch (coords)
		{
			case CARTESIAN: vector.setCartesian(v1, v2);

			case POLAR: vector.setPolar(v1, v2);
		}

		return switch (operation)
		{
			case SET: new SetShotVelocity(vector);

			case ADD: new AddShotVelocity(vector);

			case SUBTRACT: new SubtractShotVelocity(vector);
		}
	}

	private function new (vector:Vector)
	{ super(vector); }

	override public function toString():String
	{
		return "shot_velocity -spd " + this._vector.length + " -dir " + this._vector.angle;
	}
}

private class SetShotVelocity extends ShotVelocity
{
	public function new (vector:Vector)
	{ super(vector); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.set(this._vector);

		return true;
	}

	override public function toString():String
	{
		return super.toString() +	" -op set";
	}
}

private class AddShotVelocity extends ShotVelocity
{
	public function new (vector:Vector)
	{ super(vector); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.add(this._vector);

		return true;
	}

	override public function toString():String
	{ return super.toString() +	" -op add"; }
}

private class SubtractShotVelocity extends ShotVelocity
{
	public function new (vector:Vector)
	{ super(vector); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.subtract(this._vector);

		return true;
	}

	override public function toString():String
	{ return super.toString() + " -op subtract"; }
}

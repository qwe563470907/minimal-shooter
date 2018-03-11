package bloc.element;

import bloc.element.Utility;

class ShotVelocity extends Velocity
{
	public static function create(value:Array<Float>, coordsStr:String, operationStr:String):ShotVelocity
	{
		var coords = Utility.stringToCoords(coordsStr);
		var operation = Utility.stringToOperation(operationStr);

		var vector = new Vector();

		switch (coords)
		{
			case CARTESIAN: vector.setCartesian(value[0], value[1]);

			case POLAR: vector.setPolar(value[0], value[1]);
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

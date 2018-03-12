package bloc.element;

import bloc.element.ElementUtility;

class VectorElement extends DefaultElement
{
	private var _operation:Operation;
	private var _name:ElementName;

	/**
	 *  Creates a BLOC vector element (e.g. position, velocity etc.).
	 *
	 *  @param   elementName The instance of enum ElementName.
	 *  @param   v1 The first value (the x value or the vector length, depending on the coordinates).
	 *  @param   v2 The second value (the y value or the vector angle, depending on the coordinates).
	 *  @param   operation The instance of enum Operation.
	 *  @param   coords The instance of enum Coordinates.
	 *  @return  The created vector element.
	 */
	public static inline function create(elementName:ElementName, v1:Float, v2:Float, operation:Operation, coords:Coordinates):VectorElement
	{
		var vector = new Vector();

		switch (coords)
		{
			case cartesian_coords: vector.setCartesian(v1, v2);

			case polar_coords: vector.setPolar(v1, v2);
		}

		return switch (elementName)
		{
			case position_element:
				switch (operation)
				{
					case set_operation: new SetPosition(elementName, vector, operation);

					case add_operation: new AddPosition(elementName, vector, operation);

					case subtract_operation: new SubtractPosition(elementName, vector, operation);
				}

			case velocity_element:
				switch (operation)
				{
					case set_operation: new SetVelocity(elementName, vector, operation);

					case add_operation: new AddVelocity(elementName, vector, operation);

					case subtract_operation: new SubtractVelocity(elementName, vector, operation);
				}

			case shot_velocity_element:
				switch (operation)
				{
					case set_operation: new SetShotVelocity(elementName, vector, operation);

					case add_operation: new AddShotVelocity(elementName, vector, operation);

					case subtract_operation: new SubtractShotVelocity(elementName, vector, operation);
				}

			default:
				throw "Invalid element. Maybe a bug.";
		}
	}

	private var _vector:Vector;

	private function new (name:ElementName, vector:Vector, operation:Operation)
	{
		super();
		this._name = name;
		this._vector = vector;
		this._operation = operation;
	}

	override public inline function toString():String
	{
		return ElementUtility.enumToString(this._name) + " -length " + this._vector.length + " -angle " + this._vector.angle + " -operation " + ElementUtility.enumToString(this._operation);
	}
}

private class SetPosition extends VectorElement
{
	public function new (name:ElementName, vector:Vector, operation:Operation)
	{ super(name, vector, operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.position.set(this._vector);

		return true;
	}
}

private class AddPosition extends VectorElement
{
	public function new (name:ElementName, vector:Vector, operation:Operation)
	{ super(name, vector, operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.position.add(this._vector);

		return true;
	}
}

private class SubtractPosition extends VectorElement
{
	public function new (name:ElementName, vector:Vector, operation:Operation)
	{ super(name, vector, operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.position.subtract(this._vector);

		return true;
	}
}

private class SetVelocity extends VectorElement
{
	public function new (name:ElementName, vector:Vector, operation:Operation)
	{ super(name, vector, operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.motionVelocity.set(this._vector);

		return true;
	}
}

private class AddVelocity extends VectorElement
{
	public function new (name:ElementName, vector:Vector, operation:Operation)
	{ super(name, vector, operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.motionVelocity.add(this._vector);

		return true;
	}
}

private class SubtractVelocity extends VectorElement
{
	public function new (name:ElementName, vector:Vector, operation:Operation)
	{ super(name, vector, operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.subtract(this._vector);

		return true;
	}
}

private class SetShotVelocity extends VectorElement
{
	public function new (name:ElementName, vector:Vector, operation:Operation)
	{ super(name, vector, operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.set(this._vector);

		return true;
	}
}

private class AddShotVelocity extends VectorElement
{
	public function new (name:ElementName, vector:Vector, operation:Operation)
	{ super(name, vector, operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.add(this._vector);

		return true;
	}
}

private class SubtractShotVelocity extends VectorElement
{
	public function new (name:ElementName, vector:Vector, operation:Operation)
	{ super(name, vector, operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.subtract(this._vector);

		return true;
	}
}

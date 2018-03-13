package bloc.element;

import bloc.element.ElementUtility;

class VectorElement extends DefaultElement
{
	private var _name:ElementName;
	private var _vector:Vector;
	private var _operation:Operation;

	private function new (name:ElementName, vector:Vector, operation:Operation)
	{
		super();
		this._name = name;
		this._vector = vector;
		this._operation = operation;
	}

	override public function toString():String
	{
		return ElementUtility.enumToString(this._name) + " -len " + this._vector.length + " -ang " + this._vector.angle + " -op " + ElementUtility.enumToString(this._operation);
	}
}

class VectorElementBuilder
{
	/**
	 * Creates a BLOC vector element (e.g. position, velocity etc.).
	 *
	 * @param   elementName The instance of enum ElementName.
	 * @param   v1 The first value (the x value or the vector length, depending on the coordinates).
	 * @param   v2 The second value (the y value or the vector angle, depending on the coordinates).
	 * @param   operation The instance of enum Operation.
	 * @param   coords The instance of enum Coordinates.
	 * @param   reference The reference of enum Coordinates. Only for shot_position and shot_velocity elements.
	 * @return  The created vector element.
	 */
	public static inline function create(
	  elementName:ElementName,
	  v1:Float,
	  v2:Float,
	  operation:Operation,
	  coords:Coordinates,
	  reference:Null<Reference>
	):VectorElement
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
					case set_operation: new SetPosition(vector);

					case add_operation: new AddPosition(vector);

					case subtract_operation: new SubtractPosition(vector);
				}

			case velocity_element:
				switch (operation)
				{
					case set_operation: new SetVelocity(vector);

					case add_operation: new AddVelocity(vector);

					case subtract_operation: new SubtractVelocity(vector);
				}

			case shot_position_element:
				if (reference == null) throw "[BLOC] VectorElement.create(): Attribute \"reference\" is null. Maybe a bug.";

				switch (operation)
				{
					case set_operation:
						switch (reference)
						{
							case absolute_reference: new SetShotPositionAbsolute(vector);

							case relative_reference: new SetShotPositionRelative(vector);
						}

					case add_operation: new AddShotPosition(vector);

					case subtract_operation: new SubtractShotPosition(vector);
				}

			case shot_velocity_element:
				if (reference == null) throw "[BLOC] VectorElement.create(): Attribute \"reference\" is null. Maybe a bug.";

				switch (operation)
				{
					case set_operation:
						switch (reference)
						{
							case absolute_reference: new SetShotVelocityAbsolute(vector);

							case relative_reference: new SetShotVelocityRelative(vector);
						}

					case add_operation: new AddShotVelocity(vector);

					case subtract_operation: new SubtractShotVelocity(vector);
				}

			default:
				throw "[BLOC] VectorElement.create(): Invalid element. Maybe a bug.";
		}
	}
}

private class SetPosition extends VectorElement
{
	public function new (vector:Vector)
	{ super(position_element, vector, set_operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.position.set(this._vector);

		return true;
	}
}

private class AddPosition extends VectorElement
{
	public function new (vector:Vector)
	{ super(position_element, vector, add_operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.position.add(this._vector);

		return true;
	}
}

private class SubtractPosition extends VectorElement
{
	public function new (vector:Vector)
	{ super(position_element, vector, subtract_operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.position.subtract(this._vector);

		return true;
	}
}

private class SetVelocity extends VectorElement
{
	public function new (vector:Vector)
	{ super(velocity_element, vector, set_operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.velocity.set(this._vector);

		return true;
	}
}

private class AddVelocity extends VectorElement
{
	public function new (vector:Vector)
	{ super(velocity_element, vector, add_operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.velocity.add(this._vector);

		return true;
	}
}

private class SubtractVelocity extends VectorElement
{
	public function new (vector:Vector)
	{ super(velocity_element, vector, subtract_operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.subtract(this._vector);

		return true;
	}
}

private class SetShotVectorElement extends VectorElement
{
	private var _reference:Reference;

	public function new (name:ElementName, vector:Vector, reference:Reference)
	{
		super(name, vector, set_operation);
		this._reference = reference;
	}

	override public function toString():String
	{
		return super.toString() + " -ref " + ElementUtility.enumToString(this._reference);
	}
}

private class SetShotPosition extends SetShotVectorElement
{
	public function new (vector:Vector, reference:Reference)
	{ super(shot_position_element, vector, reference); }
}

private class SetShotPositionAbsolute extends SetShotPosition
{
	public function new (vector:Vector)
	{ super(vector, absolute_reference); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotPosition.setAbsoluteReference();
		actor.shotPosition.set(this._vector);

		return true;
	}
}

private class SetShotPositionRelative extends SetShotPosition
{
	public function new (vector:Vector)
	{ super(vector, relative_reference); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotPosition.setRelativeReference(actor.position);
		actor.shotPosition.set(this._vector);

		return true;
	}
}

private class AddShotPosition extends VectorElement
{
	public function new (vector:Vector)
	{ super(shot_position_element, vector, add_operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotPosition.add(this._vector);

		return true;
	}
}

private class SubtractShotPosition extends VectorElement
{
	public function new (vector:Vector)
	{ super(shot_position_element, vector, subtract_operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotPosition.subtract(this._vector);

		return true;
	}
}

private class SetShotVelocity extends SetShotVectorElement
{
	public function new (vector:Vector, reference:Reference)
	{ super(shot_velocity_element, vector, reference); }
}

private class SetShotVelocityAbsolute extends SetShotVelocity
{
	public function new (vector:Vector)
	{ super(vector, absolute_reference); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.setAbsoluteReference();
		actor.shotVelocity.set(this._vector);

		return true;
	}
}

private class SetShotVelocityRelative extends SetShotVelocity
{
	public function new (vector:Vector)
	{ super(vector, relative_reference); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.setRelativeReference(actor.velocity);
		actor.shotVelocity.set(this._vector);

		return true;
	}
}

private class AddShotVelocity extends VectorElement
{
	public function new (vector:Vector)
	{ super(shot_velocity_element, vector, add_operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.add(this._vector);

		return true;
	}
}

private class SubtractShotVelocity extends VectorElement
{
	public function new (vector:Vector)
	{ super(shot_velocity_element, vector, subtract_operation); }

	override public inline function run(actor:Actor):Bool
	{
		actor.shotVelocity.subtract(this._vector);

		return true;
	}
}

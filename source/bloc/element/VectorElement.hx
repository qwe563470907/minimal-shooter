package bloc.element;

import bloc.element.ElementUtility;
import bloc.parser.ParserUtility.elementNameToString;
import bloc.parser.VectorParser.operationToString;

class VectorElement extends DefaultElement
{
	private var _name:ElementName;
	private var _operation:Operation;

	public static function create(elementName:ElementName, v1:Float, v2:Float, coords:Coordinates, operation:Operation):VectorElement
	{
		var vector = new Vector();

		switch (coords)
		{
			case CARTESIAN: vector.setCartesian(v1, v2);

			case POLAR: vector.setPolar(v1, v2);
		}

		return switch (elementName)
		{
			case POSITION:
				switch (operation)
				{
					case SET: new SetPosition(elementName, vector, operation);

					case ADD: new AddPosition(elementName, vector, operation);

					case SUBTRACT: new SubtractPosition(elementName, vector, operation);
				}

			case VELOCITY:
				switch (operation)
				{
					case SET: new SetVelocity(elementName, vector, operation);

					case ADD: new AddVelocity(elementName, vector, operation);

					case SUBTRACT: new SubtractVelocity(elementName, vector, operation);
				}

			case SHOT_VELOCITY:
				switch (operation)
				{
					case SET: new SetShotVelocity(elementName, vector, operation);

					case ADD: new AddShotVelocity(elementName, vector, operation);

					case SUBTRACT: new SubtractShotVelocity(elementName, vector, operation);
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
		return elementNameToString(this._name) + " -spd " + this._vector.length + " -dir " + this._vector.angle + " -operation " + operationToString(this._operation);
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

package bloc.element;

import bloc.element.ElementUtility;

class ScalarElement extends DefaultElement
{
	private var _name:ElementName;
	private var _value:Float;
	private var _operation:Operation;
	private var _vectorGetter:AbstractVectorGetter;
	private var _scalarOperator:AbstractScalarOperator;

	public function new (
	  name:ElementName,
	  value:Float,
	  operation:Operation,
	  vectorGetter:AbstractVectorGetter,
	  scalarOperator:AbstractScalarOperator
	)
	{
		super();
		this._name = name;
		this._value = value;
		this._operation = operation;
		this._vectorGetter = vectorGetter;
		this._scalarOperator = scalarOperator;
	}

	override public inline function run(actor:Actor):Bool
	{
		this._scalarOperator.operate(this._vectorGetter.get(actor), this._value);

		return true;
	}

	override public function toString():String
	{
		return ElementUtility.enumToString(this._name) + " -val " + this._value + " -op " + ElementUtility.enumToString(this._operation);
	}
}

class ScalarElementBuilder
{
	/**
	 * Creates a BLOC scalar element (e.g. distance, speed etc.).
	 *
	 * @param   elementName The instance of enum ElementName.
	 * @param   value The value.
	 * @param   operation The instance of enum Operation.
	 * @return  The created vector element.
	 */
	public static inline function create(
	  elementName:ElementName,
	  value:Float,
	  operation:Operation
	):ScalarElement
	{
		var scalarOperator:AbstractScalarOperator;
		var vectorGetter:AbstractVectorGetter;

		switch (elementName)
		{
			case distance_element, speed_element, shot_distance_element, shot_speed_element:
				// Length group
				scalarOperator = switch (operation)
				{
					case set_operation: ScalarOperators.setLength;

					case add_operation: ScalarOperators.addLength;

					case subtract_operation: ScalarOperators.subtractLength;
				}

			case bearing_element, direction_element, shot_bearing_element, shot_direction_element:
				// Angle group
				scalarOperator = switch (operation)
				{
					case set_operation: ScalarOperators.setAngle;

					case add_operation: ScalarOperators.addAngle;

					case subtract_operation: ScalarOperators.subtractAngle;
				}

			default:
				throw "[BLOC] ScalarElement.create(): Invalid element. Maybe a bug.";
		}

		switch (elementName)
		{
			case distance_element, bearing_element:
				vectorGetter = VectorGetters.positionGetter;

			case speed_element, direction_element:
				vectorGetter = VectorGetters.velocityGetter;

			case shot_distance_element, shot_bearing_element:
				vectorGetter = VectorGetters.shotPositionGetter;

			case shot_speed_element, shot_direction_element:
				vectorGetter = VectorGetters.shotVelocityGetter;

			default:
				throw "[BLOC] ScalarElement.create(): Invalid element. Maybe a bug.";
		}

		return new ScalarElement(elementName, value, operation, vectorGetter, scalarOperator);
	}
}

private class ScalarOperators
{
	public static var setLength = new SetLength();
	public static var addLength = new AddLength();
	public static var subtractLength = new SubtractLength();
	public static var setAngle = new SetAngle();
	public static var addAngle = new AddAngle();
	public static var subtractAngle = new SubtractAngle();
}

private class AbstractScalarOperator
{
	public function new () {}

	public function operate(vector:Vector, value:Float):Void
	{
	}
}

private class SetLength extends AbstractScalarOperator
{
	override public inline function operate(vector:Vector, value:Float):Void
	{ vector.length = value; }
}

private class AddLength extends AbstractScalarOperator
{
	override public inline function operate(vector:Vector, value:Float):Void
	{ vector.length += value; }
}

private class SubtractLength extends AbstractScalarOperator
{
	override public inline function operate(vector:Vector, value:Float):Void
	{ vector.length -= value; }
}

private class SetAngle extends AbstractScalarOperator
{
	override public inline function operate(vector:Vector, value:Float):Void
	{ vector.angle = value; }
}

private class AddAngle extends AbstractScalarOperator
{
	override public inline function operate(vector:Vector, value:Float):Void
	{ vector.angle += value; }
}

private class SubtractAngle extends AbstractScalarOperator
{
	override public inline function operate(vector:Vector, value:Float):Void
	{ vector.angle -= value; }
}

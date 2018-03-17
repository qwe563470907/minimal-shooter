package bloc.element;

using tink.core.Ref;
import bloc.AngleInterval;
import bloc.element.ElementUtility;

class AngularVelocityElement extends DefaultElement
{
	private var _name:ElementName;
	private var _operation:Operation;
	private var _value:AngleInterval;
	private var _angularVelocityGetter:AngularVelocityGetter;
	private var _operator:AngularVelocityOperator;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:AngleInterval,
	  angularVelocityGetter:AngularVelocityGetter,
	  operator:AngularVelocityOperator
	)
	{
		super();
		this._name = name;
		this._operation = operation;
		this._value = value;
		this._angularVelocityGetter = angularVelocityGetter;
		this._operator = operator;
	}

	override public inline function run(actor:Actor):Bool
	{
		this._operator.operate(this._angularVelocityGetter.get(actor), this._value);

		return true;
	}

	override public function toString():String
	{
		return ElementUtility.enumToString(this._name) +	" -op " + ElementUtility.enumToString(this._operation) + " -val " + this._value;
	}
}



class AngularVelocityElementBuilder
{
	/**
	 * Creates a BLOC angular velocity element (e.g. bearing_angular_velocity etc.).
	 *
	 * @param   elementName The instance of enum ElementName.
	 * @param   value The value in degrees.
	 * @param   operation The instance of enum Operation.
	 * @return  The created element instance.
	 */
	public static inline function create(
	  elementName:ElementName,
	  value:Float,
	  operation:Operation
	):AngularVelocityElement
	{
		try
		{
			var angleInterval = AngleInterval.fromDegrees(value);
			var angularVelocityGetter = AngularVelocityGetters.chooseAngularVelocityGetter(elementName);
			var operator = AngularVelocityOperators.chooseAngularVelocityOperator(operation);

			return new AngularVelocityElement(elementName, operation, angleInterval, angularVelocityGetter, operator);
		}
		catch (message:String)
		{
			throw "AngleVelocityElementBulider.create(): " + message;
		}
	}
}



private class AngularVelocityGetters
{
	public static var bearingAngularVelocityGetter = new BearingAngularVelocityGetter();
	public static var directionAngularVelocityGetter = new DirectionAngularVelocityGetter();
	public static var shotBearingAngularVelocityGetter = new ShotBearingAngularVelocityGetter();
	public static var shotDirectionAngularVelocityGetter = new ShotDirectionAngularVelocityGetter();

	public static inline function chooseAngularVelocityGetter(elementName:ElementName):AngularVelocityGetter
	{

		return switch (elementName)
		{
			case bearing_angular_velocity_element: AngularVelocityGetters.bearingAngularVelocityGetter;

			case direction_angular_velocity_element: AngularVelocityGetters.directionAngularVelocityGetter;

			case shot_bearing_angular_velocity_element: AngularVelocityGetters.shotBearingAngularVelocityGetter;

			case shot_direction_angular_velocity_element: AngularVelocityGetters.shotDirectionAngularVelocityGetter;

			default:
				throw "Passed invalid element to AngularVelocityGetters private class. Maybe a bug.";
		}
	}
}

private class AngularVelocityGetter
{
	public function new ()
	{}

	public function get(actor:Actor):Ref<AngleInterval>
	{
		return AngleInterval.fromZero();	// dummy code to be overridden
	}
}

private class BearingAngularVelocityGetter extends AngularVelocityGetter
{
	override public inline function get(actor:Actor):Ref<AngleInterval>
	{ return actor.bearingAngularVelocity; }
}

private class DirectionAngularVelocityGetter extends AngularVelocityGetter
{
	override public inline function get(actor:Actor):Ref<AngleInterval>
	{ return actor.directionAngularVelocity; }
}

private class ShotBearingAngularVelocityGetter extends AngularVelocityGetter
{
	override public inline function get(actor:Actor):Ref<AngleInterval>
	{ return actor.shotBearingAngularVelocity; }
}

private class ShotDirectionAngularVelocityGetter extends AngularVelocityGetter
{
	override public inline function get(actor:Actor):Ref<AngleInterval>
	{ return actor.shotDirectionAngularVelocity; }
}



private class AngularVelocityOperators
{
	public static var setAngularVelocity = new SetAngularVelocity();
	public static var addAngularVelocity = new AddAngularVelocity();
	public static var subtractAngularVelocity = new SubtractAngularVelocity();

	public static function chooseAngularVelocityOperator(operation:Operation):AngularVelocityOperator
	{

		return switch (operation)
		{
			case set_operation: AngularVelocityOperators.setAngularVelocity;

			case add_operation: AngularVelocityOperators.addAngularVelocity;

			case subtract_operation: AngularVelocityOperators.subtractAngularVelocity;
		}
	}
}

private class AngularVelocityOperator
{
	public function new ()
	{}

	public function operate(operand:Ref<AngleInterval>, value:AngleInterval):Void
	{
	}
}

private class SetAngularVelocity extends AngularVelocityOperator
{
	override public inline function operate(operand:Ref<AngleInterval>, value:AngleInterval):Void
	{ operand.value = value; }
}

private class AddAngularVelocity extends AngularVelocityOperator
{
	override public inline function operate(operand:Ref<AngleInterval>, value:AngleInterval):Void
	{ operand.value += value; }
}

private class SubtractAngularVelocity extends AngularVelocityOperator
{
	override public inline function operate(operand:Ref<AngleInterval>, value:AngleInterval):Void
	{ operand.value -= value; }
}

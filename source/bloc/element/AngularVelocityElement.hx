package bloc.element;

using tink.core.Ref;
import bloc.AngleInterval;
import bloc.element.ElementUtility;
import bloc.state.AngleIntervalState;

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

	override public function toString():String
	{
		return ElementUtility.enumToString(this._name) +	" -op " + ElementUtility.enumToString(this._operation) + " -val " + this._value;
	}
}

class NoWaitAngularVelocityElement extends AngularVelocityElement
{
	override public inline function run(actor:Actor):Bool
	{
		this._operator.operate(this._angularVelocityGetter.get(actor), this._value);

		return true;
	}
}

class ContinuousAngularVelocityElement extends AngularVelocityElement
{
	private var _frameCount:Int;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:AngleInterval,
	  angularVelocityGetter:AngularVelocityGetter,
	  operator:AngularVelocityOperator,
	  frames:Int
	)
	{
		super(name, operation, value, angularVelocityGetter, operator);
		this._frameCount = frames;
	}

	override public function toString():String
	{
		return super.toString() + " -frm " + this._frameCount;
	}
}

class FixedContinuousAngularVelocityElement extends ContinuousAngularVelocityElement
{
	private var _dividedValue:AngleInterval;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:AngleInterval,
	  angularVelocityGetter:AngularVelocityGetter,
	  operator:AngularVelocityOperator,
	  frames:Int
	)
	{
		super(name, operation, value, angularVelocityGetter, operator, frames);
		this._dividedValue = value / cast(frames, Float);
	}

	override public inline function run(actor:Actor):Bool
	{
		this._operator.operate(this._angularVelocityGetter.get(actor), this._dividedValue);

		var countState = actor.getStateManager().getCountState(this);
		countState.increment();

		return countState.isCompleted;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		manager.addCountState(this, this._frameCount + 1);
	}

	override public inline function resetState(actor:Actor):Void
	{
		actor.getStateManager().getCountState(this).reset();
	}
}

class DynamicContinuousAngularVelocityElement extends ContinuousAngularVelocityElement
{
	override public function run(actor:Actor):Bool
	{
		var angleState = actor.getStateManager().getAngleIntervalState(this);
		var value = angleState.value;

		if (value == null) value = setValue(actor, angleState);

		this._operator.operate(this._angularVelocityGetter.get(actor), value);

		var countState = actor.getStateManager().getCountState(this);
		countState.increment();

		return countState.isCompleted;
	}

	override public function prepareState(manager:StateManager):Void
	{
		manager.addCountState(this, this._frameCount + 1);
		manager.addAngleIntervalState(this);
	}

	override public function resetState(actor:Actor):Void
	{
		var manager = actor.getStateManager();
		manager.getCountState(this).reset();
		manager.getAngleIntervalState(this).reset();
	}

	private function setValue(actor:Actor, state:AngleIntervalState):AngleInterval
	{
		var currentValue = this._angularVelocityGetter.get(actor).value;
		var valueDifference = this._value - currentValue;

		return state.value = valueDifference / (this._frameCount + 1);
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
	 * @param   frames The duration frame count.
	 * @return  The created element instance.
	 */
	public static inline function create(
	  elementName:ElementName,
	  value:Float,
	  operation:Operation,
	  frames:Int
	):AngularVelocityElement
	{
		try
		{
			var angleInterval = AngleInterval.fromDegrees(value);
			var angularVelocityGetter = AngularVelocityGetters.chooseAngularVelocityGetter(elementName);
			var operator = AngularVelocityOperators.chooseAngularVelocityOperator(operation);

			return if (frames == 0)
				new NoWaitAngularVelocityElement(elementName, operation, angleInterval, angularVelocityGetter, operator);
			else
			{
				switch (operation)
				{
					case set_operation:
						new DynamicContinuousAngularVelocityElement(elementName, operation, angleInterval, angularVelocityGetter, AngularVelocityOperators.addAngularVelocity, frames);

					case add_operation, subtract_operation:
						new FixedContinuousAngularVelocityElement(elementName, operation, angleInterval, angularVelocityGetter, operator, frames);
				}
			}

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

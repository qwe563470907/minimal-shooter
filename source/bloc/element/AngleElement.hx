package bloc.element;

import bloc.DirectionAngle;
import bloc.AngleInterval;
import bloc.element.ElementUtility;
import bloc.Utility.DirectionAngleRef;
import bloc.state.AngleIntervalState;

class AngleElement extends DefaultElement
{
	private var _name:ElementName;
	private var _operation:Operation;
	private var _vectorGetter:AbstractVectorGetter;
	private var _angleGetter:AbstractAngleGetter;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  vectorGetter:AbstractVectorGetter,
	  angleGetter:AbstractAngleGetter
	)
	{
		super();
		this._name = name;
		this._operation = operation;
		this._vectorGetter = vectorGetter;
		this._angleGetter = angleGetter;
	}

	override public function toString():String
	{
		return ElementUtility.enumToString(this._name) +	" -op " + ElementUtility.enumToString(this._operation);
	}

	private inline function getOperandAngle(actor:Actor):DirectionAngleRef
	{
		return this._angleGetter.get(this._vectorGetter.get(actor));
	}
}

class SetAngleElement extends AngleElement
{
	private var _value:DirectionAngle;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:DirectionAngle,
	  vectorGetter:AbstractVectorGetter,
	  angleGetter:AbstractAngleGetter
	)
	{
		super(name, operation, vectorGetter, angleGetter);
		this._value = value;
	}

	override public function toString():String
	{
		return super.toString() + " -ang " + this._value;
	}
}

class NoWaitSetAngleElement extends SetAngleElement
{
	private var _angleOperator:AngleSetter;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:DirectionAngle,
	  vectorGetter:AbstractVectorGetter,
	  angleGetter:AbstractAngleGetter
	)
	{
		super(name, operation, value, vectorGetter, angleGetter);
		this._angleOperator = AngleOperators.setAngle;
	}

	override public inline function run(actor:Actor):Bool
	{
		this._angleOperator.operate(this.getOperandAngle(actor), this._value);

		return true;
	}
}

class DynamicContinuousChangeAngleElement extends SetAngleElement
{
	private var _angleOperator:AbstractAngleChanger;
	private var _frameCount:Int;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:DirectionAngle,
	  vectorGetter:AbstractVectorGetter,
	  angleGetter:AbstractAngleGetter,
	  frames:Int
	)
	{
		super(name, operation, value, vectorGetter, angleGetter);
		this._angleOperator = AngleOperators.addAngle;
		this._frameCount = frames;
	}

	override public function run(actor:Actor):Bool
	{
		var angleState = actor.getStateManager().getAngleIntervalState(this);
		var value = angleState.value;

		if (value == null) value = setValue(actor, angleState);

		this._angleOperator.operate(this._angleGetter.get(this._vectorGetter.get(actor)), value);

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

	override public inline function containsWait():Bool
	{
		return true;
	}

	private function setValue(actor:Actor, state:AngleIntervalState):AngleInterval
	{
		var currentValue = this._angleGetter.get(this._vectorGetter.get(actor)).value;
		var valueDifference = Utility.angleDifference(this._value, currentValue);

		return state.value = valueDifference / (this._frameCount + 1);
	}
}

class ChangeAngleElement extends AngleElement
{
	private var _value:AngleInterval;
	private var _angleOperator:AbstractAngleChanger;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:AngleInterval,
	  vectorGetter:AbstractVectorGetter,
	  angleGetter:AbstractAngleGetter,
	  angleOperator:AbstractAngleChanger
	)
	{
		super(name, operation, vectorGetter, angleGetter);
		this._value = value;
		this._angleOperator = angleOperator;
	}

	override public function toString():String
	{
		return super.toString() + " -ang " + this._value;
	}
}

class NoWaitChangeAngleElement extends ChangeAngleElement
{
	override public inline function run(actor:Actor):Bool
	{
		this._angleOperator.operate(this.getOperandAngle(actor), this._value);

		return true;
	}
}

class ContinuousChangeAngleElement extends ChangeAngleElement
{
	private var _frameCount:Int;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:AngleInterval,
	  vectorGetter:AbstractVectorGetter,
	  angleGetter:AbstractAngleGetter,
	  angleOperator:AbstractAngleChanger,
	  frames:Int
	)
	{
		super(name, operation, value, vectorGetter, angleGetter, angleOperator);
		this._frameCount = frames;
	}

	override public function toString():String
	{
		return super.toString() + " -frm " + this._frameCount;
	}

	override public inline function containsWait():Bool
	{
		return true;
	}
}

class FixedContinuousChangeAngleElement extends ContinuousChangeAngleElement
{
	private var _dividedValue:AngleInterval;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:AngleInterval,
	  vectorGetter:AbstractVectorGetter,
	  angleGetter:AbstractAngleGetter,
	  angleOperator:AbstractAngleChanger,
	  frames:Int
	)
	{
		super(name, operation, value, vectorGetter, angleGetter, angleOperator, frames);
		this._dividedValue = value / cast(frames, Float);
	}

	override public inline function run(actor:Actor):Bool
	{
		this._angleOperator.operate(this._angleGetter.get(this._vectorGetter.get(actor)), this._dividedValue);

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



class AngleElementBuilder
{
	/**
	 * Creates a BLOC angular element (e.g. bearing, direction etc.).
	 *
	 * @param   elementName The instance of enum ElementName.
	 * @param   value The value in BLOC degrees (0 for North, clockwise).
	 * @param   operation The instance of enum Operation.
	 * @param   frames The duration frame count.
	 * @return  The created element instance.
	 */
	public static inline function create(
	  elementName:ElementName,
	  value:Float,
	  operation:Operation,
	  frames:Int
	):AngleElement
	{
		try
		{
			var vectorGetter = VectorGetters.chooseVectorGetter(elementName);
			var angleGetter = AngleGetters.chooseAngleGetter(elementName);

			return if (frames == 0)
			{
				switch (operation)
				{
					case set_operation:
						var angle = DirectionAngle.fromBlocDegrees(value);
						new NoWaitSetAngleElement(elementName, operation, angle, vectorGetter, angleGetter);

					case add_operation, subtract_operation:
						var angleInterval = AngleInterval.fromDegrees(value);
						var angleOperator = AngleOperators.chooseAngleChanger(operation);
						new NoWaitChangeAngleElement(elementName, operation, angleInterval, vectorGetter, angleGetter, angleOperator);
				}
			}
			else
			{
				var angleInterval = AngleInterval.fromDegrees(value);

				switch (operation)
				{
					case set_operation:
						var angle = DirectionAngle.fromBlocDegrees(value);
						new DynamicContinuousChangeAngleElement(elementName, operation, angle, vectorGetter, angleGetter, frames);

					case add_operation, subtract_operation:
						var angleOperator = AngleOperators.chooseAngleChanger(operation);
						new FixedContinuousChangeAngleElement(elementName, operation, angleInterval, vectorGetter, angleGetter, angleOperator, frames);
				}
			}
		}
		catch (message:String)
		{
			throw "AngleElementBuilder.create(): " + message;
		}
	}
}



private class AngleOperators
{
	public static var setAngle = new AngleSetter();
	public static var addAngle = new AddAngleChanger();
	public static var subtractAngle = new SubtractAngleChanger();

	public static inline function chooseAngleChanger(operation:Operation):AbstractAngleChanger
	{

		return switch (operation)
		{
			case set_operation: throw "Passed invalid element. Maybe a bug.";

			case add_operation: AngleOperators.addAngle;

			case subtract_operation: AngleOperators.subtractAngle;
		}
	}
}

private class AngleSetter
{
	public function new () {}

	public inline function operate(operand:DirectionAngleRef, value:DirectionAngle):Void
	{ operand.value = value; }
}

private class AbstractAngleChanger
{
	public function new () {}

	public function operate(operand:DirectionAngleRef, value:AngleInterval):Void
	{
	}
}

private class AddAngleChanger extends AbstractAngleChanger
{
	override public inline function operate(operand:DirectionAngleRef, value:AngleInterval):Void
	{ operand.value += value; }
}

private class SubtractAngleChanger extends AbstractAngleChanger
{
	override public inline function operate(operand:DirectionAngleRef, value:AngleInterval):Void
	{ operand.value -= value; }
}

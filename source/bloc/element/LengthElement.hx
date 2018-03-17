package bloc.element;

import bloc.element.ElementUtility;
import bloc.state.FloatState;
import bloc.Utility.FloatRef;

class LengthElement extends DefaultElement
{
	private var _name:ElementName;
	private var _operation:Operation;
	private var _value:Float;
	private var _vectorGetter:AbstractVectorGetter;
	private var _floatGetter:AbstractFloatGetter;
	private var _scalarOperator:AbstractFloatOperator;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:Float,
	  vectorGetter:AbstractVectorGetter,
	  floatGetter:AbstractFloatGetter,
	  scalarOperator:AbstractFloatOperator
	)
	{
		super();
		this._name = name;
		this._operation = operation;
		this._value = value;
		this._vectorGetter = vectorGetter;
		this._floatGetter = floatGetter;
		this._scalarOperator = scalarOperator;
	}

	override public function toString():String
	{
		return (
		  ElementUtility.enumToString(this._name) +
		  " -op " + ElementUtility.enumToString(this._operation) +
		  " -val " + this._value
		);
	}
}

class NoWaitLengthElement extends LengthElement
{
	override public inline function run(actor:Actor):Bool
	{
		this._scalarOperator.operate(this._floatGetter.get(this._vectorGetter.get(actor)), this._value);

		return true;
	}
}

class ContinuousLengthElement extends LengthElement
{
	private var _frameCount:Int;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:Float,
	  vectorGetter:AbstractVectorGetter,
	  floatGetter:AbstractFloatGetter,
	  scalarOperator:AbstractFloatOperator,
	  frames:Int
	)
	{
		super(name, operation, value, vectorGetter, floatGetter, scalarOperator);
		this._frameCount = frames;
	}

	override public function toString():String
	{
		return super.toString() + " -frm " + this._frameCount;
	}
}

class FixedContinuousLengthElement extends ContinuousLengthElement
{
	private var _dividedValue:Float;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:Float,
	  vectorGetter:AbstractVectorGetter,
	  floatGetter:AbstractFloatGetter,
	  scalarOperator:AbstractFloatOperator,
	  frames:Int
	)
	{
		super(name, operation, value, vectorGetter, floatGetter, scalarOperator, frames);
		this._dividedValue = value / cast(frames, Float);
	}

	override public inline function run(actor:Actor):Bool
	{
		this._scalarOperator.operate(this._floatGetter.get(this._vectorGetter.get(actor)), this._dividedValue);

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

class DynamicContinuousLengthElement extends ContinuousLengthElement
{
	override public function run(actor:Actor):Bool
	{
		var scalarState = actor.getStateManager().getFloatState(this);
		var value = scalarState.value;

		if (value == null) value = setValue(actor, scalarState);

		this._scalarOperator.operate(this._floatGetter.get(this._vectorGetter.get(actor)), value);

		var countState = actor.getStateManager().getCountState(this);
		countState.increment();

		return countState.isCompleted;
	}

	override public function prepareState(manager:StateManager):Void
	{
		manager.addCountState(this, this._frameCount + 1);
		manager.addFloatState(this);
	}

	override public function resetState(actor:Actor):Void
	{
		var manager = actor.getStateManager();
		manager.getCountState(this).reset();
		manager.getFloatState(this).reset();
	}

	private function setValue(actor:Actor, state:FloatState):Float
	{
		var currentValue = this._floatGetter.get(this._vectorGetter.get(actor)).value;
		var valueDifference = this._value - currentValue;

		return state.value = valueDifference / (this._frameCount + 1);
	}
}



class LengthElementBuilder
{
	/**
	 * Creates a BLOC scalar element (e.g. distance, speed etc.).
	 *
	 * @param   elementName The instance of enum ElementName.
	 * @param   value The value.
	 * @param   operation The instance of enum Operation.
	 * @param	  frames The duration frame count.
	 * @return  The created vector element.
	 */
	public static inline function create(
	  elementName:ElementName,
	  value:Float,
	  operation:Operation,
	  frames:Int
	):LengthElement
	{
		try
		{
			var vectorGetter = VectorGetters.chooseVectorGetter(elementName);
			var floatGetter = FloatGetters.chooseFloatGetter(elementName);

			return if (frames == 0)
			{
				var scalarOperator = FloatOperators.chooseLengthOperator(operation);
				new NoWaitLengthElement(elementName, operation, value, vectorGetter, floatGetter, scalarOperator);
			}
			else
			{
				switch (operation)
				{
					case set_operation:
						new DynamicContinuousLengthElement(elementName, operation, value, vectorGetter, floatGetter, FloatOperators.addFloat, frames);

					case add_operation, subtract_operation:
						var scalarOperator = FloatOperators.chooseLengthOperator(operation);
						new FixedContinuousLengthElement(elementName, operation, value, vectorGetter, floatGetter, scalarOperator, frames);
				}
			}
		}
		catch (message:String)
		{
			throw "LengthElement.create(): " + message;
		}
	}
}



private class FloatOperators
{
	public static var setFloat = new SetFloatOperator();
	public static var addFloat = new AddFloatOperator();
	public static var subtractFloat = new SubtractFloatOperator();

	public static inline function chooseLengthOperator(operation:Operation):AbstractFloatOperator
	{

		return switch (operation)
		{
			case set_operation: FloatOperators.setFloat;

			case add_operation: FloatOperators.addFloat;

			case subtract_operation: FloatOperators.subtractFloat;
		}
	}
}

private class AbstractFloatOperator
{
	public function new () {}

	public function operate(operand:FloatRef, value:Float):Void
	{
	}
}

private class SetFloatOperator extends AbstractFloatOperator
{
	override public inline function operate(operand:FloatRef, value:Float):Void
	{ operand.value = value; }
}

private class AddFloatOperator extends AbstractFloatOperator
{
	override public inline function operate(operand:FloatRef, value:Float):Void
	{ operand.value += value; }
}

private class SubtractFloatOperator extends AbstractFloatOperator
{
	override public inline function operate(operand:FloatRef, value:Float):Void
	{ operand.value -= value; }
}

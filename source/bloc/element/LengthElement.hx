package bloc.element;

import bloc.element.ElementUtility;

class LengthElement extends DefaultElement
{
	private var _name:ElementName;
	private var _value:Float;
	private var _operation:Operation;
	private var _vectorGetter:AbstractVectorGetter;
	private var _scalarOperator:AbstractLengthOperator;

	public function new (
	  name:ElementName,
	  value:Float,
	  operation:Operation,
	  vectorGetter:AbstractVectorGetter,
	  scalarOperator:AbstractLengthOperator
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
		return (
		  ElementUtility.enumToString(this._name) +
		  " -op " + ElementUtility.enumToString(this._operation) +
		  " -val " + this._value
		);
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
	 * @return  The created vector element.
	 */
	public static inline function create(
	  elementName:ElementName,
	  value:Float,
	  operation:Operation
	):LengthElement
	{
		try
		{
			var scalarOperator = LengthOperators.chooseLengthOperator(operation);
			var vectorGetter = VectorGetters.chooseVectorGetter(elementName);

			return new LengthElement(elementName, value, operation, vectorGetter, scalarOperator);
		}
		catch (message:String)
		{
			throw "LengthElement.create(): " + message;
		}
	}
}

private class LengthOperators
{
	public static var setLength = new SetLength();
	public static var addLength = new AddLength();
	public static var subtractLength = new SubtractLength();

	public static inline function chooseLengthOperator(operation:Operation):AbstractLengthOperator
	{

		return switch (operation)
		{
			case set_operation: LengthOperators.setLength;

			case add_operation: LengthOperators.addLength;

			case subtract_operation: LengthOperators.subtractLength;
		}
	}
}

private class AbstractLengthOperator
{
	public function new () {}

	public function operate(vector:Vector, value:Float):Void
	{
	}
}

private class SetLength extends AbstractLengthOperator
{
	override public inline function operate(vector:Vector, value:Float):Void
	{ vector.length = value; }
}

private class AddLength extends AbstractLengthOperator
{
	override public inline function operate(vector:Vector, value:Float):Void
	{ vector.length += value; }
}

private class SubtractLength extends AbstractLengthOperator
{
	override public inline function operate(vector:Vector, value:Float):Void
	{ vector.length -= value; }
}

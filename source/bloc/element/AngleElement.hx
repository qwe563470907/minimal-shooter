package bloc.element;

import bloc.DirectionAngle;
import bloc.AngleInterval;
import bloc.element.ElementUtility;

class AngleElement extends DefaultElement
{
	private var _name:ElementName;
	private var _operation:Operation;
	private var _vectorGetter:AbstractVectorGetter;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  vectorGetter:AbstractVectorGetter
	)
	{
		super();
		this._name = name;
		this._operation = operation;
		this._vectorGetter = vectorGetter;
	}

	override public function toString():String
	{
		return ElementUtility.enumToString(this._name) +	" -op " + ElementUtility.enumToString(this._operation);
	}
}

class SetAngleElement extends AngleElement
{
	private var _value:DirectionAngle;

	public function new (
	  name:ElementName,
	  value:DirectionAngle,
	  operation:Operation,
	  vectorGetter:AbstractVectorGetter
	)
	{
		super(name, operation, vectorGetter);
		this._value = value;
	}

	override public inline function run(actor:Actor):Bool
	{
		this._vectorGetter.get(actor).angle = this._value;

		return true;
	}

	override public function toString():String
	{
		return super.toString() + " -ang " + this._value;
	}
}

class RelativeAngleElement extends AngleElement
{
	private var _value:AngleInterval;

	public function new (
	  name:ElementName,
	  value:AngleInterval,
	  operation:Operation,
	  vectorGetter:AbstractVectorGetter
	)
	{
		super(name, operation, vectorGetter);
		this._value = value;
	}

	override public function toString():String
	{
		return super.toString() + " -ang " + this._value;
	}
}

class AddAngleElement extends RelativeAngleElement
{
	override public inline function run(actor:Actor):Bool
	{
		this._vectorGetter.get(actor).angle += this._value;

		return true;
	}
}

class SubtractAngleElement extends RelativeAngleElement
{
	override public inline function run(actor:Actor):Bool
	{
		this._vectorGetter.get(actor).angle -= this._value;

		return true;
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
	 * @return  The created vector element.
	 */
	public static inline function create(
	  elementName:ElementName,
	  value:Float,
	  operation:Operation
	):AngleElement
	{
		try
		{
			var vectorGetter = VectorGetters.chooseVectorGetter(elementName);

			return switch (operation)
			{
				case set_operation:
					var angle = DirectionAngle.fromBlocDegrees(value);
					new SetAngleElement(elementName, angle, operation, vectorGetter);

				case add_operation:
					var angleInterval = AngleInterval.fromDegrees(value);
					new AddAngleElement(elementName, angleInterval, operation, vectorGetter);

				case subtract_operation:
					var angleInterval = AngleInterval.fromDegrees(value);
					new SubtractAngleElement(elementName, angleInterval, operation, vectorGetter);
			}
		}
		catch (message:String)
		{
			throw "AngleElement.create(): " + message;
		}
	}
}

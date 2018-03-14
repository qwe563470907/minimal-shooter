package bloc.element;

import bloc.element.ElementUtility;

class VectorElement extends DefaultElement
{
	private var _name:ElementName;
	private var _valueVector:Vector;
	private var _operation:Operation;
	private var _operandVectorGetter:AbstractVectorGetter;
	private var _vectorOperator:AbstractVectorOperator;
	private var _referenceSetter:AbstractReferenceSetter;
	private var _referenceVectorGetter:AbstractVectorGetter;

	public function new (
	  name:ElementName,
	  valueVector:Vector,
	  operation:Operation,
	  operandVectorGetter:AbstractVectorGetter,
	  vectorOperator:AbstractVectorOperator,
	  referenceSetter:AbstractReferenceSetter,
	  referenceVectorGetter:AbstractVectorGetter
	)
	{
		super();
		this._name = name;
		this._valueVector = valueVector;
		this._operation = operation;
		this._operandVectorGetter = operandVectorGetter;
		this._vectorOperator = vectorOperator;
		this._referenceSetter = referenceSetter;
		this._referenceVectorGetter = referenceVectorGetter;
	}

	override public inline function run(actor:Actor):Bool
	{
		var operandVector = this._operandVectorGetter.get(actor);
		this._referenceSetter.set(operandVector, this._referenceVectorGetter.get(actor));
		this._vectorOperator.operate(operandVector, this._valueVector);

		return true;
	}

	override public function toString():String
	{
		return ElementUtility.enumToString(this._name) + " -len " + this._valueVector.length + " -ang " + this._valueVector.angle + " -op " + ElementUtility.enumToString(this._operation);
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

		var operandVectorGetter = switch (elementName)
		{
			case position_element:
				VectorGetters.positionGetter;

			case velocity_element:
				VectorGetters.velocityGetter;

			case shot_position_element:
				VectorGetters.shotPositionGetter;

			case shot_velocity_element:
				VectorGetters.shotVelocityGetter;

			default:
				throw "[BLOC] ScalarElement.create(): Invalid element. Maybe a bug.";
		}

		var vectorOperator:AbstractVectorOperator;
		var referenceSetter:AbstractReferenceSetter = ReferenceSetters.nullReferenceSetter;
		var referenceVectorGetter:AbstractVectorGetter = VectorGetters.nullVectorGetter;

		switch (operation)
		{
			case set_operation:
				vectorOperator = VectorOperators.setVector;

				switch (elementName)
				{
					case shot_position_element:
						switch (reference)
						{
							case null:
								throw "[BLOC] VectorElement.create(): Attribute \"reference\" is null. Maybe a bug.";

							case absolute_reference:
								referenceSetter = ReferenceSetters.absoluteReferenceSetter;
								referenceVectorGetter = VectorGetters.nullVectorGetter;

							case relative_reference:
								referenceSetter = ReferenceSetters.relativeReferenceSetter;
								referenceVectorGetter = VectorGetters.positionGetter;
						}

					case shot_velocity_element:
						switch (reference)
						{
							case null:
								throw "[BLOC] VectorElement.create(): Attribute \"reference\" is null. Maybe a bug.";

							case absolute_reference:
								referenceSetter = ReferenceSetters.absoluteReferenceSetter;
								referenceVectorGetter = VectorGetters.nullVectorGetter;

							case relative_reference:
								referenceSetter = ReferenceSetters.relativeReferenceSetter;
								referenceVectorGetter = VectorGetters.velocityGetter;
						}

					default:
				}

			case add_operation:
				vectorOperator = VectorOperators.addVector;

			case subtract_operation:
				vectorOperator = VectorOperators.subtractVector;
		}

		return new VectorElement(
		    elementName,
		    vector,
		    operation,
		    operandVectorGetter,
		    vectorOperator,
		    referenceSetter,
		    referenceVectorGetter
		  );
	}
}



private class VectorOperators
{
	public static var setVector = new SetVector();
	public static var addVector = new AddVector();
	public static var subtractVector = new SubtractVector();
}

private class AbstractVectorOperator
{
	public function new () {}

	public function operate(operandVector:Vector, otherVector:Vector):Void
	{
	}
}

private class SetVector extends AbstractVectorOperator
{
	override public inline function operate(operandVector:Vector, otherVector:Vector):Void
	{ operandVector.set(otherVector); }
}

private class AddVector extends AbstractVectorOperator
{
	override public inline function operate(operandVector:Vector, otherVector:Vector):Void
	{ operandVector.add(otherVector); }
}

private class SubtractVector extends AbstractVectorOperator
{
	override public inline function operate(operandVector:Vector, otherVector:Vector):Void
	{ operandVector.subtract(otherVector); }
}



private class ReferenceSetters
{
	public static var absoluteReferenceSetter = new AbsoluteReferenceSetter();
	public static var relativeReferenceSetter = new RelativeReferenceSetter();
	public static var nullReferenceSetter = new NullReferenceSetter();
}

private class AbstractReferenceSetter
{
	public function new () {}

	public function set(operandVector:Vector, referenceVector:Vector):Void
	{
	}
}

private class AbsoluteReferenceSetter extends AbstractReferenceSetter
{
	override public inline function set(operandVector:Vector, referenceVector:Vector):Void
	{
		operandVector.setAbsoluteReference();
	}
}

private class RelativeReferenceSetter extends AbstractReferenceSetter
{
	override public inline function set(operandVector:Vector, referenceVector:Vector):Void
	{
		operandVector.setRelativeReference(referenceVector);
	}
}

private class NullReferenceSetter extends AbstractReferenceSetter
{
	override public inline function set(operandVector:Vector, referenceVector:Vector):Void
	{
	}
}

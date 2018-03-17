package bloc.element;

import bloc.DirectionAngle;
import bloc.element.ElementUtility;
import bloc.state.VectorState;

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

	override public function toString():String
	{
		return (
		  ElementUtility.enumToString(this._name) +
		  " -op " + ElementUtility.enumToString(this._operation) +
		  " -len " + this._valueVector.length +
		  " -ang " + this._valueVector.angle
		);
	}
}

class NoWaitVectorElement extends VectorElement
{
	override public inline function run(actor:Actor):Bool
	{
		var operandVector = this._operandVectorGetter.get(actor);
		this._referenceSetter.set(operandVector, this._referenceVectorGetter.get(actor));
		this._vectorOperator.operate(operandVector, this._valueVector);

		return true;
	}
}

class ContinuousVectorElement extends VectorElement
{
	private var _frameCount:Int;

	public function new (
	  name:ElementName,
	  valueVector:Vector,
	  operation:Operation,
	  operandVectorGetter:AbstractVectorGetter,
	  vectorOperator:AbstractVectorOperator,
	  referenceSetter:AbstractReferenceSetter,
	  referenceVectorGetter:AbstractVectorGetter,
	  frames:Int
	)
	{
		super(name, valueVector, operation, operandVectorGetter, vectorOperator, referenceSetter, referenceVectorGetter);
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

class FixedContinuousVectorElement extends ContinuousVectorElement
{
	private var _dividedValue:Vector;

	public function new (
	  name:ElementName,
	  valueVector:Vector,
	  operation:Operation,
	  operandVectorGetter:AbstractVectorGetter,
	  vectorOperator:AbstractVectorOperator,
	  referenceSetter:AbstractReferenceSetter,
	  referenceVectorGetter:AbstractVectorGetter,
	  frames:Int
	)
	{
		super(name, valueVector, operation, operandVectorGetter, vectorOperator, referenceSetter, referenceVectorGetter, frames);
		this._dividedValue = new Vector().set(valueVector);
		this._dividedValue.length /= cast(frames, Float);
	}

	override public inline function run(actor:Actor):Bool
	{
		var operandVector = this._operandVectorGetter.get(actor);

		var countState = actor.getStateManager().getCountState(this);

		if (countState.count == 0)
			this._referenceSetter.set(operandVector, this._referenceVectorGetter.get(actor));

		this._vectorOperator.operate(operandVector, this._dividedValue);

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

class DynamicContinuousVectorElement extends ContinuousVectorElement
{
	override public inline function run(actor:Actor):Bool
	{
		var operandVector = this._operandVectorGetter.get(actor);
		var vectorState = actor.getStateManager().getVectorState(this);
		var value = vectorState.value;

		var countState = actor.getStateManager().getCountState(this);

		if (countState.count == 0)
			this._referenceSetter.set(operandVector, this._referenceVectorGetter.get(actor));

		if (value == null) value = setValue(actor, vectorState);

		this._vectorOperator.operate(operandVector, value);

		countState.increment();

		return countState.isCompleted;
	}

	override public function prepareState(manager:StateManager):Void
	{
		manager.addCountState(this, this._frameCount + 1);
		manager.addVectorState(this);
	}

	override public function resetState(actor:Actor):Void
	{
		var manager = actor.getStateManager();
		manager.getCountState(this).reset();
		manager.getVectorState(this).reset();
	}

	private function setValue(actor:Actor, state:VectorState):Vector
	{
		var currentValue = this._operandVectorGetter.get(actor);
		var valuePerFrame = new Vector().set(this._valueVector);	// Todo: avoid instanciation
		valuePerFrame.subtract(currentValue);
		valuePerFrame.length /= (this._frameCount + 1);

		return state.value = valuePerFrame;
	}
}



class VectorElementBuilder
{
	/**
	 * Creates a BLOC vector element (e.g. position, velocity etc.).
	 *
	 * @param   elementName The instance of enum ElementName.
	 * @param   v1 The first value (the x value or the vector length, depending on the coordinates).
	 * @param   v2 The second value (the y value or the vector direction angle in BLOC degrees, depending on the coordinates).
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
	  reference:Null<Reference>,
	  frames:Int
	):VectorElement
	{
		try
		{
			var valueVector = createValueVector(v1, v2, coords);
			var operandVectorGetter = VectorGetters.chooseVectorGetter(elementName);
			var vectorOperator = VectorOperators.chooseVectorOperator(operation);

			var validatedReference = validateReference(operation, elementName, reference);
			var referenceSetter = ReferenceSetters.chooseReferenceSetter(validatedReference);

			var referenceVectorGetter = switch (validatedReference)
			{
				case absolute_reference: VectorGetters.nullVectorGetter;

				case relative_reference:
					switch (elementName)
					{
						case shot_position_element: VectorGetters.positionGetter;

						case shot_velocity_element: VectorGetters.velocityGetter;

						default: throw "Validation of reference failed. Maybe a bug.";
					}

				case null: VectorGetters.nullVectorGetter;
			}

			return if (frames == 0)
				  new NoWaitVectorElement(
				    elementName,
				    valueVector,
				    operation,
				    operandVectorGetter,
				    vectorOperator,
				    referenceSetter,
				    referenceVectorGetter
				  );
			else
			{
				switch (operation)
				{
					case set_operation:
						new DynamicContinuousVectorElement(
						  elementName,
						  valueVector,
						  operation,
						  operandVectorGetter,
						  VectorOperators.addVector,
						  referenceSetter,
						  referenceVectorGetter,
						  frames
						);

					case add_operation, subtract_operation:
						new FixedContinuousVectorElement(
						  elementName,
						  valueVector,
						  operation,
						  operandVectorGetter,
						  vectorOperator,
						  referenceSetter,
						  referenceVectorGetter,
						  frames
						);
				}
			}
		}
		catch (message:String)
		{
			throw "VectorElement.create(): " + message;
		}
	}

	private static inline function createValueVector(v1:Float, v2:Float, coords:Coordinates):Vector
	{
		var vector = new Vector();

		switch (coords)
		{
			case cartesian_coords: vector.setCartesian(v1, v2);

			case polar_coords: vector.setPolar(v1, DirectionAngle.fromBlocDegrees(v2));
		}

		return vector;
	}

	private static inline function validateReference(operation:Operation, elementName:ElementName, reference:Reference):Null<Reference>
	{

		return switch (operation)
		{
			case set_operation:
				switch (elementName)
				{
					case shot_position_element, shot_velocity_element:
						switch (reference)
						{
							case null: throw "Attribute \"reference\" is null. Maybe a bug.";

							default: reference;
						}

					default: null;
				}

			default: null;
		}
	}
}



private class VectorOperators
{
	public static var setVector = new SetVector();
	public static var addVector = new AddVector();
	public static var subtractVector = new SubtractVector();

	public static inline function chooseVectorOperator(operation:Operation):AbstractVectorOperator
	{

		return switch (operation)
		{
			case set_operation: VectorOperators.setVector;

			case add_operation: VectorOperators.addVector;

			case subtract_operation: VectorOperators.subtractVector;
		}
	}
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

	public static inline function chooseReferenceSetter(reference:Reference):AbstractReferenceSetter
	{

		return switch (reference)
		{
			case absolute_reference: ReferenceSetters.absoluteReferenceSetter;

			case relative_reference: ReferenceSetters.relativeReferenceSetter;

			case null: ReferenceSetters.nullReferenceSetter;
		}
	}
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

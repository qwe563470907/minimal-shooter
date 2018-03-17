package bloc.element;

import bloc.AngleInterval;
import bloc.element.ElementUtility;

class AngularVelocityElement extends DefaultElement
{
	private var _name:ElementName;
	private var _operation:Operation;
	private var _value:AngleInterval;

	public function new (
	  name:ElementName,
	  operation:Operation,
	  value:AngleInterval
	)
	{
		super();
		this._name = name;
		this._operation = operation;
		this._value = value;
	}

	override public function run(actor:Actor):Bool
	{
		operate(actor);

		return true;
	}

	public function operate(actor:Actor):Void
	{
	}

	override public function toString():String
	{
		return ElementUtility.enumToString(this._name) +	" -op " + ElementUtility.enumToString(this._operation) + " -val " + this._value;
	}
}

class SetBearingAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.bearingAngularVelocity = this._value; }
}

class AddBearingAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.bearingAngularVelocity += this._value; }
}

class SubtractBearingAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.bearingAngularVelocity -= this._value; }
}

class SetDirectionAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.directionAngularVelocity = this._value; }
}

class AddDirectionAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.directionAngularVelocity += this._value; }
}

class SubtractDirectionAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.directionAngularVelocity -= this._value; }
}

class SetShotBearingAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.shotBearingAngularVelocity = this._value; }
}

class AddShotBearingAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.shotBearingAngularVelocity += this._value; }
}

class SubtractShotBearingAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.shotBearingAngularVelocity -= this._value; }
}

class SetShotDirectionAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.shotDirectionAngularVelocity = this._value; }
}

class AddShotDirectionAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.shotDirectionAngularVelocity += this._value; }
}

class SubtractShotDirectionAngularVelocityElement extends AngularVelocityElement
{
	override public inline function operate(actor:Actor):Void
	{ actor.shotDirectionAngularVelocity -= this._value; }
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

			return switch (elementName)
			{
				case bearing_angular_velocity_element:
					switch (operation)
					{
						case set_operation: new SetBearingAngularVelocityElement(elementName, operation, angleInterval);

						case add_operation: new AddBearingAngularVelocityElement(elementName, operation, angleInterval);

						case subtract_operation: new SubtractBearingAngularVelocityElement(elementName, operation, angleInterval);
					}

				case direction_angular_velocity_element:
					switch (operation)
					{
						case set_operation: new SetDirectionAngularVelocityElement(elementName, operation, angleInterval);

						case add_operation: new AddDirectionAngularVelocityElement(elementName, operation, angleInterval);

						case subtract_operation: new SubtractDirectionAngularVelocityElement(elementName, operation, angleInterval);
					}

				case shot_bearing_angular_velocity_element:
					switch (operation)
					{
						case set_operation: new SetShotBearingAngularVelocityElement(elementName, operation, angleInterval);

						case add_operation: new AddShotBearingAngularVelocityElement(elementName, operation, angleInterval);

						case subtract_operation: new SubtractShotBearingAngularVelocityElement(elementName, operation, angleInterval);
					}

				case shot_direction_angular_velocity_element:
					switch (operation)
					{
						case set_operation: new SetShotDirectionAngularVelocityElement(elementName, operation, angleInterval);

						case add_operation: new AddShotDirectionAngularVelocityElement(elementName, operation, angleInterval);

						case subtract_operation: new SubtractShotDirectionAngularVelocityElement(elementName, operation, angleInterval);
					}

				default:
					throw "Invalid element. Maybe a bug.";
			}
		}
		catch (message:String)
		{
			throw "AngleVelocityElementBulider.create(): " + message;
		}
	}
}

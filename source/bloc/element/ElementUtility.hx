package bloc.element;

using bloc.Utility;
import bloc.Utility.*;

class ElementUtility
{
	/**
	 * Indents the provided string with two spaces for each line.
	 *
	 * @param   str
	 * @return  String
	 */
	public static inline function indent(str:String):String
	{
		return "  " + StringTools.replace(str, "\n", "\n  ");
	}

	/**
	 * Converts the provided enum instance to string, removing the suffix beginning at the last underscore.
	 *
	 * @param   enumInstance The enum instance to convert.
	 * @return  The converted string.
	 */
	public static inline function enumToString<T:EnumValue>(enumInstance:T):String
	{
		var str = Std.string(enumInstance);
		var lastUnderscoreIndex = str.lastIndexOf("_");

		return str.substring(0, if (lastUnderscoreIndex > 0) lastUnderscoreIndex else str.length);
	}
}

enum Operation
{
	set_operation;

	add_operation;

	subtract_operation;
}

enum Coordinates
{
	cartesian_coords;
	polar_coords;
}

enum Reference
{
	absolute_reference;
	relative_reference;
}

enum ElementName
{
	position_element;
	distance_element;
	bearing_element;
	bearing_angular_velocity_element;

	velocity_element;
	speed_element;
	direction_element;
	direction_angular_velocity_element;

	shot_position_element;
	shot_distance_element;
	shot_bearing_element;
	shot_bearing_angular_velocity_element;

	shot_velocity_element;
	shot_speed_element;
	shot_direction_element;
	shot_direction_angular_velocity_element;

	fire_element;

	wait_element;

	sequence_element;
	parallel_element;
	async_element;
	endless_element;

	loop_element;

	if_element;
	command_element;

	null_element;
}


class VectorGetters
{
	public static var positionGetter = new PositionGetter();
	public static var velocityGetter = new VelocityGetter();
	public static var shotPositionGetter = new ShotPositionGetter();
	public static var shotVelocityGetter = new ShotVelocityGetter();
	public static var nullVectorGetter = new NullVectorGetter();

	public static inline function chooseVectorGetter(elementName:ElementName):AbstractVectorGetter
	{

		return switch (elementName)
		{
			case position_element, distance_element, bearing_element:
				VectorGetters.positionGetter;

			case velocity_element, speed_element, direction_element:
				VectorGetters.velocityGetter;

			case shot_position_element, shot_distance_element, shot_bearing_element:
				VectorGetters.shotPositionGetter;

			case shot_velocity_element, shot_speed_element, shot_direction_element:
				VectorGetters.shotVelocityGetter;

			default:
				throw "Passed invalid element to VectorGetters class. Maybe a bug.";
		}
	}
}

class AbstractVectorGetter
{
	public function new () {}

	public function get(actor:Actor):Vector
	{
		return new Vector();	// dummy to be overridden
	}
}

private class PositionGetter extends AbstractVectorGetter
{
	override public inline function get(actor:Actor):Vector
	{ return actor.position; }
}

private class VelocityGetter extends AbstractVectorGetter
{
	override public inline function get(actor:Actor):Vector
	{ return actor.velocity; }
}

private class ShotPositionGetter extends AbstractVectorGetter
{
	override public inline function get(actor:Actor):Vector
	{ return actor.shotPosition; }
}

private class ShotVelocityGetter extends AbstractVectorGetter
{
	override public inline function get(actor:Actor):Vector
	{ return actor.shotVelocity; }
}

private class NullVectorGetter extends AbstractVectorGetter
{
	private static var dummyVector = new Vector();

	override public inline function get(actor:Actor):Vector
	{ return dummyVector; }
}



class FloatGetters
{
	public static var xGetter = new XGetter();
	public static var yGetter = new YGetter();
	public static var lengthGetter = new LengthGetter();

	public static inline function chooseFloatGetter(elementName:ElementName):AbstractFloatGetter
	{

		return switch (elementName)
		{
			case distance_element, speed_element, shot_distance_element, shot_speed_element: FloatGetters.lengthGetter;

			default:
				throw "Passed invalid element to FloatGetters class. Maybe a bug.";
		}
	}
}

class AbstractFloatGetter
{
	public function new () {}

	public function get(vector:Vector):FloatRef
	{
		return NULL_FLOAT_REF;	// dummy to be overridden
	}
}

private class XGetter extends AbstractFloatGetter
{
	override public inline function get(vector:Vector):FloatRef
	{ return vector.xRef; }
}

private class YGetter extends AbstractFloatGetter
{
	override public inline function get(vector:Vector):FloatRef
	{ return vector.yRef; }
}

private class LengthGetter extends AbstractFloatGetter
{
	override public inline function get(vector:Vector):FloatRef
	{ return vector.lengthRef; }
}



class AngleGetters
{
	public static var angleGetter = new AngleGetter();

	public static inline function chooseAngleGetter(elementName:ElementName):AbstractAngleGetter
	{

		return switch (elementName)
		{
			case bearing_element, direction_element, shot_bearing_element, shot_direction_element: AngleGetters.angleGetter;

			default:
				throw "Passed invalid element to DirectionAngleGetters class. Maybe a bug.";
		}
	}
}

class AbstractAngleGetter
{
	public function new () {}

	public function get(vector:Vector):DirectionAngleRef
	{
		return NULL_DIRECTION_ANGLE_REF;	// dummy to be overridden
	}
}

private class AngleGetter extends AbstractAngleGetter
{
	override public inline function get(vector:Vector):DirectionAngleRef
	{ return vector.angleRef; }
}

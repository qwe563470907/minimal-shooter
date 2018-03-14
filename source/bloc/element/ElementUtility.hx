package bloc.element;

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
	velocity_element;
	speed_element;
	direction_element;
	shot_position_element;
	shot_distance_element;
	shot_bearing_element;
	shot_velocity_element;
	shot_speed_element;
	shot_direction_element;
	fire_element;
	wait_element;
	sequence_element;
	parallel_element;
	repeat_element;
	endless_element;
	if_element;
	null_element;
}


class VectorGetters
{
	public static var positionGetter = new PositionGetter();
	public static var velocityGetter = new VelocityGetter();
	public static var shotPositionGetter = new ShotPositionGetter();
	public static var shotVelocityGetter = new ShotVelocityGetter();
	public static var nullVectorGetter = new NullVectorGetter();
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

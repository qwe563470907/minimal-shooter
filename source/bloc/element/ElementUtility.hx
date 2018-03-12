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

enum ElementName
{
	position_element;
	velocity_element;
	shot_position_element;
	shot_velocity_element;
	fire_element;
	wait_element;
	sequence_element;
	parallel_element;
	repeat_element;
	endless_element;
	if_element;
	null_element;
}

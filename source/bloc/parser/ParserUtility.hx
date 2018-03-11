package bloc.parser;

import yaml.util.ObjectMap;
import bloc.element.ElementUtility.ElementName;

class ParserUtility
{
	public static inline function stringToElementName(value:String):ElementName
	{

		return switch (value)
		{
			case "position":
				POSITION;

			case "velocity":
				VELOCITY;

			case "shot_velocity":
				SHOT_VELOCITY;

			case "fire":
				FIRE;

			case "wait":
				WAIT;

			case "sequence":
				SEQUENCE;

			case "parallel":
				PARALLEL;

			case "repeat":
				REPEAT;

			case "endless":
				ENDLESS;

			case "if":
				IF;

			default:
				NULL;
		}
	}

	public static inline function elementNameToString(value:ElementName):String
	{

		return switch (value)
		{
			case POSITION:
				"position";

			case VELOCITY:
				"velocity";

			case SHOT_VELOCITY:
				"shot_velocity";

			case FIRE:
				"fire";

			case WAIT:
				"wait";

			case SEQUENCE:
				"sequence";

			case PARALLEL:
				"parallel";

			case REPEAT:
				"repeat";

			case ENDLESS:
				"endless";

			case IF:
				"if";

			case NULL:
				"null";
		}
	}

	public static inline function isMap(value:Null<Dynamic>):Bool
	{
		return Std.is(value, AnyObjectMap) == true;
	}

	public static inline function isSequence(value:Null<Dynamic>):Bool
	{
		return Std.is(value, Array) == true;
	}

	public static inline function isInt(value:Null<Dynamic>):Bool
	{
		return Std.is(value, Int) == true;
	}

	public static inline function isFloat(value:Null<Dynamic>):Bool
	{
		return Std.is(value, Float) == true;
	}

	public static inline function isString(value:Null<Dynamic>):Bool
	{
		return Std.is(value, String) == true;
	}

	public static inline function isBool(value:Null<Dynamic>):Bool
	{
		return Std.is(value, Bool) == true;
	}

	public static inline function getType(value:Null<Dynamic>):DataType
	{
		var type:DataType;

		if (value == null) type = NULL;
		else if (isMap(value)) type = MAP;
		else if (isSequence(value)) type = SEQUENCE;
		else if (isInt(value)) type = INTEGER;
		else if (isFloat(value)) type = FLOAT;
		else if (isString(value)) type = STRING;
		else if (isBool(value)) type = BOOLEAN;
		else type = OTHER;

		return type;
	}
}

enum DataType
{
	MAP;
	SEQUENCE;
	INTEGER;
	FLOAT;
	STRING;
	BOOLEAN;
	NULL;
	OTHER;
}

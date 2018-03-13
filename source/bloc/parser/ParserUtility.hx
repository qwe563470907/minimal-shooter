package bloc.parser;

import yaml.util.ObjectMap;

class ParserUtility
{
	/**
	 * Converts a string extracted from BLOC file to an enum instance.
	 *
	 * @param   str The string to convert.
	 * @param   suffix The suffix for the internal names of the enum constructors. (e.g. "element")
	 * @param   enumObj The enum object.
	 * @param   attributeName The name for using in the error message if the string was not convertable.
	 * @param   defaultValue The default enum instance.
	 * @return  The converted enum instance, or the provided default value if the provided string was not convertable.
	 */
	public static inline function stringToEnum<T>(str: Null<Dynamic>, suffix:String, enumObj:Enum<T>, attributeName:String, defaultValue:T):T
	{
		var enumInstance:T;

		if (str == null || str == "") enumInstance = defaultValue;
		else
			try { enumInstance = Type.createEnum(enumObj, str + "_" + suffix); }
			catch (unknown:Dynamic)
			{
				trace("[BLOC] Warning: Invalid " + attributeName + ": " + str);
				enumInstance = defaultValue;
			}

		return enumInstance;
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

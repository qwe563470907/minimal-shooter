package bloc.parser;

import bloc.element.Element;
import bloc.element.Utility;
import bloc.parser.Parser.NonParsedElement;

class VectorParser
{
	static public function parse(name:String, content: Null<Dynamic>):Element
	{
		try
		{
			if (content == null)
				throw "Found no attributes.";

			if (Std.is(content, NonParsedElement) != true)
				throw "Invalid attributes. The attributes must be written in a map format.";

			var value = content.get("value");

			if (value == null)
				throw "Found no \"value\" attribute.";

			try { value = cast(value, Array<Dynamic>); }
			catch (msg:String) { throw "Invalid \"value\" attribute. This must be an array of two numbers."; }

			if (value.length != 2)
				throw "Invalid \"value\" attribute. This must be an array of two numbers.";

			if (Std.is(value[0], Float) != true || Std.is(value[1], Float) != true)
				throw "Invalid \"value\" attribute. This must be an array of two numbers.";

			var coords = stringToCoords(content.get("coordinates"), POLAR);
			var operation = stringToOperation(content.get("operation"), SET);

			return bloc.element.ShotVelocity.create(value[0], value[1], coords, operation);
		}
		catch (message:String)
		{
			trace("[BLOC] Warning: Element <" + name + ">: " + message);

			return Utility.NULL_ELEMENT;
		}
	}

	static public function stringToOperation(op: Dynamic, defaultValue:Operation):Operation
	{

		return switch (op)
		{
			case "", null: defaultValue;

			case "set": SET;

			case "add": ADD;

			case "subtract": SUBTRACT;

			default: throw "Invalid operation type: " + op;
		}
	}

	static public function operationToString(op: Operation):String
	{

		return switch (op)
		{
			case SET: "set";

			case ADD: "add";

			case SUBTRACT: "sub";
		}
	}

	static public function stringToCoords(coords: Null<String>, defaultValue:Coordinates):Coordinates
	{

		return switch (coords)
		{
			case "", null: defaultValue;

			case "cartesian": CARTESIAN;

			case "polar": POLAR;

			default: throw "Invalid coordinates: " + coords;
		}
	}

	static public function coordsToString(op: Coordinates):String
	{

		return switch (op)
		{
			case CARTESIAN: "cartesian";

			case POLAR: "polar";
		}
	}
}
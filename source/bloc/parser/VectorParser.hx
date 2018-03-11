package bloc.parser;

import bloc.element.Element;
import bloc.element.ElementUtility.ElementName;
import bloc.element.ElementUtility.Coordinates;
import bloc.element.ElementUtility.Operation;
import bloc.element.VectorElement;
import bloc.parser.ParserUtility.*;

class VectorParser
{
	static public function parse(elementName:ElementName, content: Null<Dynamic>):Element
	{
		try
		{
			if (content == null)
				throw "Found no attributes.";

			if (isMap(content))
			{
				var value = content.get("value");

				if (value == null)
					throw "Found no \"value\" attribute.";

				if (!isSequence(value))
					throw "Invalid \"value\" attribute. This must be an array of two numbers.";

				if (!isValidValue(value))
					throw "Invalid \"value\" attribute. This must be an array of two numbers.";

				var coords = stringToCoords(content.get("coordinates"), POLAR);
				var operation = stringToOperation(content.get("operation"), SET);

				return VectorElement.create(elementName, value[0], value[1], coords, operation);
			}
			else if (isSequence(content))
			{
				if (!isValidValue(content))
					throw "Invalid \"value\" attribute. This must be an array of two numbers.";

				return VectorElement.create(elementName, content[0], content[1], POLAR, SET);
			}
			else
				throw "Invalid attributes. The attributes must be either a map or an array of two numbers.";
		}
		catch (message:String)
		{
			trace("[BLOC] Warning: Element <" + elementNameToString(elementName) + ">: " + message);

			return Utility.NULL_ELEMENT;
		}
	}

	static private function isValidValue(array:Array<Dynamic>):Bool
	{
		return array.length == 2 && isFloat(array[0]) && isFloat(array[1]);
	}

	static public function stringToOperation(op: Dynamic, defaultValue:Operation):Operation
	{

		return switch (op)
		{
			case "", null: defaultValue;

			case "set": SET;

			case "add": ADD;

			case "subtract": SUBTRACT;

			default: throw "Invalid operation: " + op;
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

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
				var values = content.get("values");

				if (values == null)
					throw "Found no \"values\" attribute.";

				if (!isSequence(values))
					throw "Invalid \"values\" attribute: " + values;

				if (!isValidValues(values))
					throw "Invalid \"values\" attribute: " + values;

				var operation = stringToOperation(content.get("operation"), SET);

				var defaultCoords = if (elementName == POSITION && operation == SET) CARTESIAN else POLAR;

				var coords = stringToCoords(content.get("coordinates"), defaultCoords);

				return VectorElement.create(elementName, values[0], values[1], operation, coords);
			}
			else if (isSequence(content))
			{
				if (!isValidContentArray(content))
					throw "Invalid attributes: " + content;

				var operation = stringToOperation(content[2], SET);

				var defaultCoords = if (elementName == POSITION && operation == SET) CARTESIAN else POLAR;

				var coords = stringToCoords(content[3], defaultCoords);

				return VectorElement.create(elementName, content[0], content[1], operation, coords);
			}
			else
				throw "Invalid attributes. The attributes must be either a map or an array.";
		}
		catch (message:String)
		{
			trace("[BLOC] Warning: Element <" + elementNameToString(elementName) + ">: " + message);

			return Utility.NULL_ELEMENT;
		}
	}

	static private inline function isValidValues(array:Array<Dynamic>):Bool
	{
		return array.length == 2 && isFloat(array[0]) && isFloat(array[1]);
	}

	static private inline function isValidContentArray(array:Array<Dynamic>):Bool
	{
		return array.length >= 2 && array.length <= 4 && isFloat(array[0]) && isFloat(array[1]);
	}

	static public inline function stringToOperation(op: Null<Dynamic>, defaultValue:Operation):Operation
	{

		return switch (op)
		{
			case "", null: defaultValue;

			case "set": SET;

			case "add": ADD;

			case "subtract": SUBTRACT;

			default:
				trace("[BLOC] Invalid operation: " + op);
				defaultValue;
		}
	}

	static public inline function operationToString(op: Operation):String
	{

		return switch (op)
		{
			case SET: "set";

			case ADD: "add";

			case SUBTRACT: "sub";
		}
	}

	static public inline function stringToCoords(coords: Null<Dynamic>, defaultValue:Coordinates):Coordinates
	{

		return switch (coords)
		{
			case "", null: defaultValue;

			case "cartesian": CARTESIAN;

			case "polar": POLAR;

			default:
				trace("[BLOC] Warning: Invalid coordinates: " + coords);
				defaultValue;
		}
	}

	static public inline function coordsToString(op: Coordinates):String
	{

		return switch (op)
		{
			case CARTESIAN: "cartesian";

			case POLAR: "polar";
		}
	}
}

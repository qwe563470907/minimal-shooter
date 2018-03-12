package bloc.parser;

import bloc.element.Element;
import bloc.element.ElementUtility;
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

				var operation = stringToEnum(content.get("operation"), "operation", Operation, "operation", set_operation);

				var defaultCoords = if (elementName == position_element && operation == set_operation) cartesian_coords else polar_coords;

				var coords = stringToEnum(content.get("coordinates"), "coords", Coordinates, "coordinates", defaultCoords);

				return VectorElement.create(elementName, values[0], values[1], operation, coords);
			}
			else if (isSequence(content))
			{
				if (!isValidContentArray(content))
					throw "Invalid attributes: " + content;

				var operation = stringToEnum(content[2], "operation", Operation, "operation", set_operation);

				var defaultCoords = if (elementName == position_element && operation == set_operation) cartesian_coords else polar_coords;

				var coords = stringToEnum(content[3], "coords", Coordinates, "coordinates", defaultCoords);

				return VectorElement.create(elementName, content[0], content[1], operation, coords);
			}
			else
				throw "Invalid attributes. The attributes must be either a map or an array.";
		}
		catch (message:String)
		{
			trace("[BLOC] Warning: Element <" + ElementUtility.enumToString(elementName) + ">: " + message);

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
}

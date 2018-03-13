package bloc.parser;

import bloc.element.Element;
import bloc.element.ElementUtility;
import bloc.element.VectorElement;
import bloc.parser.ParserUtility.*;

class VectorParser
{
	/**
	 * Parses the content of any vector element.
	 *
	 * @param   content The content of any vector element. This should be either:
	 *     (1) a mapping of attributes:
	 *         "values" (an array of two numbers),
	 *         "operation",
	 *         "coordinates",
	 *         "reference".
	 *     (2) an array of:
	 *         value1, value2, operation, coordinates, reference.
	 *     Only the values are mandatory.
	 *     The "reference" attribute is used only for cases where element is either "shot_position" or "shot_velocity" and operation is "set".
	 *     This format will be checked in this method.
	 * @return  The parsed element instance.
	 */
	static public function parse(elementName:ElementName, content: Null<Dynamic>):Element
	{
		var element:Element;

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

				var operation = getOperation(content.get("operation"));
				var coords = getCoordinates(content.get("coordinates"));
				var reference = getReference(content.get("reference"), elementName, operation);
				element = VectorElementBuilder.create(elementName, values[0], values[1], operation, coords, reference);
			}
			else if (isSequence(content))
			{
				if (!isValidContentArray(content))
					throw "Invalid attributes: " + content;

				var arrayLength:Int = content.length;
				var operation = getOperation(if (arrayLength >= 3) content[2] else null);
				var coords = getCoordinates(if (arrayLength >= 4) content[3] else null);
				var reference = getReference(if (arrayLength >= 5) content[4] else null, elementName, operation);

				element = VectorElementBuilder.create(elementName, content[0], content[1], operation, coords, reference);
			}
			else
				throw "Invalid attributes. The attributes must be either a map or an array.";
		}
		catch (message:String)
		{
			trace("[BLOC] Warning: Element <" + ElementUtility.enumToString(elementName) + ">: " + message);
			element = Utility.NULL_ELEMENT;
		}

		return element;
	}

	private static inline function isValidValues(array:Array<Dynamic>):Bool
	{
		return array.length == 2 && isFloat(array[0]) && isFloat(array[1]);
	}

	private static inline function isValidContentArray(array:Array<Dynamic>):Bool
	{
		return array.length >= 2 && isFloat(array[0]) && isFloat(array[1]);
	}

	private static inline function getOperation(operationValue:Null<Dynamic>):Operation
	{
		return stringToEnum(operationValue, "operation", Operation, "operation", add_operation);
	}

	private static inline function getCoordinates(coordinatesValue:Null<Dynamic>):Coordinates
	{
		return stringToEnum(coordinatesValue, "coords", Coordinates, "coordinates", polar_coords);
	}

	private static inline function getReference(referenceValue:Null<Dynamic>, elementName:ElementName, operation:Operation):Null<Reference>
	{

		return switch (elementName)
		{
			case shot_position_element, shot_velocity_element:
				switch (operation)
				{
					case set_operation:
						stringToEnum(referenceValue, "reference", Reference, "reference", getDefaultReference(elementName));

					default:
						null;
				}

			default:
				null;
		}
	}

	private static inline function getDefaultReference(elementName:ElementName):Reference
	{

		return switch (elementName)
		{
			case shot_position_element: relative_reference;

			case shot_velocity_element: absolute_reference;

			default: throw "[BLOC] VectorParser class: Reached the code which should be unreachable. Maybe a bug.";
		}
	}
}

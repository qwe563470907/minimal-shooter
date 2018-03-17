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
	 *         "operation",
	 *         "values" (an array of two numbers),
	 *         "coordinates",
	 *         "reference",
	 *         "frames".
	 *     (2) an array of:
	 *         operation, value1, value2, coordinates (reference and frames cannot be specified).
	 *     The operation and values are mandatory. The "coordinates" attribute is "polar" at default.
	 *     The "reference" attribute is used only for cases where element is either "shot_position" or "shot_velocity" and operation is "set".
	 *     The "frames" attribute is 0 at default.
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
				validateValues(values);
				var value1 = values[0];
				var value2 = values[1];

				var operationString = content.get("operation");
				validateOperation(operationString);
				var operation = getOperation(operationString);

				var coords = getCoordinates(content.get("coordinates"));
				var reference = getReference(content.get("reference"), elementName, operation);

				var frames = content.get("frames");

				if (frames == null) frames = 0;

				validateFrames(frames);

				element = VectorElementBuilder.create(elementName, value1, value2, operation, coords, reference, frames);
			}
			else if (isSequence(content))
			{
				validateContentArray(content);

				var operation = getOperation(content[0]);
				var value1 = content[1];
				var value2 = content[2];

				var arrayLength:Int = content.length;
				var coords = getCoordinates(if (arrayLength >= 4) content[3] else null);

				var reference = getReference(null, elementName, operation);	// get default value
				var frames = 0;

				element = VectorElementBuilder.create(elementName, value1, value2, operation, coords, reference, frames);
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

	private static inline function validateOperation(operationString:Null<Dynamic>):Void
	{
		if (operationString == null || operationString == "")
			throw "Found no \"operation\" attribute.";

		if (!isString(operationString))
			throw "Invalid \"operation\" attribute: " + operationString;
	}

	private static inline function validateValues(values:Null<Dynamic>):Void
	{
		if (values == null)
			throw "Found no \"values\" attribute.";

		if (!isSequence(values) || values.length != 2 || !isFloat(values[0]) || !isFloat(values[1]))
			throw "Invalid \"values\" attribute: " + values;
	}

	private static inline function validateContentArray(array:Array<Dynamic>):Void
	{
		if (array.length < 3) throw "Not enough attributes.";

		validateOperation(array[0]);

		if (!isFloat(array[1]) || !isFloat(array[2]))
			throw "Invalid attributes: " + array;
	}

	private static inline function validateFrames(frames:Null<Dynamic>):Void
	{
		if (frames != null && (!isInt(frames) || frames < 0))
			throw "Invalid \"frames\" attribute: " + frames + "\nThis must be zero or a positive integer.";
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

			default: throw "VectorParser class: Reached the code which should be unreachable. Maybe a bug.";
		}
	}
}

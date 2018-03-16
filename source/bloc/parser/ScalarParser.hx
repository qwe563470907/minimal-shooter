package bloc.parser;

import bloc.element.Element;
import bloc.element.ElementUtility;
import bloc.element.LengthElement;
import bloc.element.AngleElement;
import bloc.parser.ParserUtility.*;

class ScalarParser
{
	/**
	 * Parses the content of any scalar element.
	 *
	 * @param   content The content of any scalar element. This should be either:
	 *     (1) a mapping of attributes: "operation", "value".
	 *     (2) an array of: operation, value.
	 *     Both attributes are mandatory.
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
				var operationString = content.get("operation");
				validateOperation(operationString);
				var operation = getOperation(operationString);

				var value = content.get("value");
				validateValue(value);

				element = createElementInstance(elementName, value, operation);
			}
			else if (isSequence(content))
			{
				validateContentArray(content);
				var operation = getOperation(content[0]);
				var value = content[1];
				element = createElementInstance(elementName, value, operation);
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

	private static inline function validateValue(value:Null<Dynamic>):Void
	{
		if (value == null)
			throw "Found no \"value\" attribute.";

		if (!isFloat(value))
			throw "Invalid \"value\" attribute: " + value;
	}

	private static inline function validateContentArray(array:Array<Dynamic>):Void
	{
		if (array.length < 2) throw "Not enough attributes.";

		validateOperation(array[0]);
		validateValue(array[1]);
	}

	private static inline function getOperation(operationValue:Null<Dynamic>):Operation
	{
		return stringToEnum(operationValue, "operation", Operation, "operation", set_operation);
	}

	private static inline function createElementInstance(elementName:ElementName, value:Float, operation:Operation):Element
	{

		return switch (elementName)
		{
			case distance_element, speed_element, shot_distance_element, shot_speed_element:
				LengthElementBuilder.create(elementName, value, operation);

			case bearing_element, direction_element, shot_bearing_element, shot_direction_element:
				AngleElementBuilder.create(elementName, value, operation);

			default:
				throw "Invalid element. Maybe a bug.";

		}
	}
}

package bloc.parser;

import bloc.element.Element;
import bloc.element.ElementUtility;
import bloc.element.ScalarElement;
import bloc.parser.ParserUtility.*;

class ScalarParser
{
	/**
	 * Parses the content of any scalar element.
	 *
	 * @param   content The content of any scalar element. This should be either:
	 *     (1) a mapping of attributes: "value", "operation".
	 *     (2) an array of: value, operation.
	 *     (3) a value number.
	 *     Only the value is mandatory. Default operation is "add".
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
				var value = content.get("value");

				if (value == null)
					throw "Found no \"value\" attribute.";

				if (!isFloat(value))
					throw "Invalid \"value\" attribute: " + value;

				var operation = getOperation(content.get("operation"));
				element = ScalarElementBuilder.create(elementName, value, operation);
			}
			else if (isSequence(content))
			{
				if (!isValidContentArray(content))
					throw "Invalid attributes: " + content;

				var operation = getOperation(if (content.length >= 2) content[1] else null);

				element = ScalarElementBuilder.create(elementName, content[0], operation);
			}
			else if (isFloat(content))
				element = ScalarElementBuilder.create(elementName, content, add_operation);
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

	private static inline function isValidContentArray(array:Array<Dynamic>):Bool
	{
		return array.length >= 1 && isFloat(array[0]);
	}

	private static inline function getOperation(operationValue:Null<Dynamic>):Operation
	{
		return stringToEnum(operationValue, "operation", Operation, "operation", add_operation);
	}
}

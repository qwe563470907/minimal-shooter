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

				element = ScalarElementBuilder.create(elementName, value, operation);
			}
			else if (isSequence(content))
			{
				validateContentArray(content);
				var operation = getOperation(content[0]);
				var value = content[1];
				element = ScalarElementBuilder.create(elementName, value, operation);
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
}

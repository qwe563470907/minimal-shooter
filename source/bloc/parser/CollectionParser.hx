package bloc.parser;

import bloc.element.Element;
import bloc.element.Sequence;
import bloc.element.Parallel;
import bloc.element.ElementUtility;
import bloc.parser.ParserUtility.isSequence;

class CollectionParser
{
	/**
	 * Parses the content of collection element (such as <sequence>, <parallel>).
	 *
	 * @param   elementName The instance of enum ElementName.
	 * @param   content The content of the element. This should be an array of non-parsed elements (will be checked in this method).
	 * @return  The parsed element instance.
	 */
	static public inline function parse(elementName:ElementName, content: Null<Dynamic>):Element
	{
		if (content == null)
			throw "No content.";

		if (!isSequence(content))
			throw "Invalid content. Following object must be a list of elements:\n" + content;

		var elements = PatternParser.parseElementArray(content);

		return switch (elementName)
		{
			case sequence_element: new Sequence(elements);

			case parallel_element: new Parallel(elements);

			default: throw "Passed invalid element. Maybe a bug.";
		}
	}
}
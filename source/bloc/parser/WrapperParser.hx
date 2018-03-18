package bloc.parser;

import bloc.element.Element;
import bloc.element.Endless;
import bloc.element.Async;
import bloc.element.ElementUtility.ElementName;

class WrapperParser
{
	/**
	 * Parses the content of wrapper element (such as <endless>, <async>).
	 * The <loop> element will be parsed by LoopParser class.
	 *
	 * @param   elementName The instance of enum ElementName.
	 * @param   content The content of the element.
	 * @return  The parsed element instance.
	 */
	static public inline function parse(elementName:ElementName, content: Null<Dynamic>):Element
	{

		return switch (elementName)
		{
			case endless_element:
				var endlessPattern = new Endless(PatternParser.parsePatternContent(content));

				if (!endlessPattern.containsWait())
					throw "Invalid content. Contains no element which takes one or more frames.";

				endlessPattern;

			case async_element:
				new Async(PatternParser.parsePatternContent(content));

			default:
				throw "Passed invalid element. Maybe a bug.";
		}
	}
}

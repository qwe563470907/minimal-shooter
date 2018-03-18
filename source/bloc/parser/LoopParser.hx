package bloc.parser;

import bloc.Utility.NULL_PATTERN;
import bloc.element.Element;
import bloc.element.Loop;
import bloc.parser.ParserUtility.*;

class LoopParser
{
	/**
	 * Parses the content of <loop> element.
	 *
	 * @param   content The content of <loop> element. This should be a map of attributes ("pattern" and "count").
	 * @return  The parsed <loop> element instance.
	 */
	static public inline function parse(content: Null<Dynamic>):Element
	{
		if (content == null)
			throw "No content.";

		if (!isMap(content))
			throw "Invalid content. Following object must be a map of attributes:\n" + content;

		var element:Element;
		var contentPattern = PatternParser.parsePatternContent(content.get("pattern"));

		if (contentPattern == NULL_PATTERN) throw "No valid pattern.";

		var count = content.get("count");

		if (!isInt(count)) throw "Invalid \"count\" attribute: " + count + "\nThis must be an integer.";

		element = new Loop(contentPattern, count);

		return element;
	}
}

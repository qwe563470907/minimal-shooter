package bloc.parser;

import bloc.Utility.NULL_ELEMENT;
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
		var element:Element;

		try
		{
			if (content == null)
				throw "No content.";
			else if (isMap(content))
			{
				var contentPattern = PatternParser.parsePatternContent(content.get("pattern"));

				if (contentPattern == NULL_PATTERN) throw "No valid pattern.";

				var count = content.get("count");

				if (!isInt(count)) throw "Invalid \"count\" attribute: " + count + "\nThis must be an integer.";

				element = new Loop(contentPattern, count);
			}
			else
				throw "Following object must be a map of attributes:\n" + content;
		}
		catch (message:String)
		{
			trace("[BLOC] Warning: Element <loop>: " + message);
			element = NULL_ELEMENT;
		}

		return element;
	}
}

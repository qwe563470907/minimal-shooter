package bloc.parser;

import bloc.Utility.NULL_PATTERN;
import bloc.element.Element;
import bloc.element.Fire;
import bloc.parser.ParserUtility.*;

class FireParser
{
	/**
	 * Parses the content of <fire> element.
	 *
	 * @param   content The content of <fire> element. This should be either:
	 *     (1) a map of attributes (including "pattern" attribute) or
	 *     (2) shorthand format: the content of a pattern directly specified (any of null, a list of elements or a pattern name)
	 * @return  The parsed <fire> element instance.
	 */
	static public inline function parse(content: Null<Dynamic>):Element
	{
		var pattern:Pattern;

		try
		{
			if (isMap(content))
			{
				var patternValue:Null<Dynamic> = content.get("pattern");
				pattern = PatternParser.parsePatternContent(patternValue);
			}
			else
				pattern = PatternParser.parsePatternContent(content);	// Interpret as a pattern.
		}
		catch (unknown:Dynamic)
		{
			pattern = NULL_PATTERN;
		}

		return new Fire(pattern);
	}
}

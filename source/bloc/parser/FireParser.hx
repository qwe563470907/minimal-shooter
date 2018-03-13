package bloc.parser;

import bloc.Utility.NULL_PATTERN;
import bloc.element.Element;
import bloc.element.Fire;
import bloc.parser.ParserUtility.*;

class FireParser
{
	static public inline function parse(content: Null<Dynamic>):Element
	{
		var pattern:Pattern;

		try
		{
			/**
			 * The content should be either:
			 * - a map of attributes (including "pattern" attribute)
			 * - shorthand format: directly specify the content of a pattern  (any of null, a list of elements or a pattern name)
			 */
			if (isMap(content))
			{
				var patternValue:Null<Dynamic> = content.get("pattern");
				pattern =PatternParser.parsePatternContent(patternValue);
			}
			else
				pattern =PatternParser.parsePatternContent(content);	// Interpret as a pattern.
		}
		catch (unknown:Dynamic)
		{
			pattern = NULL_PATTERN;
		}

		return new Fire(pattern);
	}
}

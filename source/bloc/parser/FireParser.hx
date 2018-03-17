package bloc.parser;

import bloc.Utility.NULL_ELEMENT;
import bloc.element.Element;
import bloc.element.Fire;
import bloc.parser.ParserUtility.*;

class FireParser
{
	/**
	 * Parses the content of <fire> element.
	 *
	 * @param   content The content of <fire> element. This should be either:
	 *     (1) a map of attributes ("pattern" and "bind") or
	 *     (2) shorthand format: the content of a pattern directly specified (any of null, a list of elements or a pattern name)
	 * @return  The parsed <fire> element instance.
	 */
	static public inline function parse(content: Null<Dynamic>):Element
	{
		var element:Element;

		try
		{

			element = if (isMap(content))
			{
				var patternValue:Null<Dynamic> = content.get("pattern");
				var pattern = PatternParser.parsePatternContent(patternValue);

				var bind = content.get("bind");

				if (bind == null)
					bind = false;
				else if (!isBool(bind))
					throw "Invalid \"bind\" attribute: " + bind + "\nThis must be a boolean data.";

				new Fire(pattern, bind);
			}
			else
			{
				var pattern = PatternParser.parsePatternContent(content);	// Interpret as a pattern.
				var bind = false;
				new Fire(pattern, bind);
			}
		}
		catch (unknown:Dynamic)
		{
			trace("[BLOC] Warning: Element <fire>: " + unknown);
			element = NULL_ELEMENT;
		}

		return element;
	}
}

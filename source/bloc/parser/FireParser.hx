package bloc.parser;

import bloc.Utility.NULL_ELEMENT;
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
			pattern =
			{
				/**
				 * The content should be any of the following:
				 * - null
				 * - a list of elements
				 * - a map of attributes (including "pattern" attribute)
				 * - a pattern name
				 */
				if (content == null)
					NULL_PATTERN;
				else if (isSequence(content))
				{
					var element = PatternParser.parseAndFoldElements(content);	// Interpret as a list of elements.

					if (element != NULL_ELEMENT) new Pattern("anonymous", element);
					else NULL_PATTERN;
				}
				else if (isMap(content))
				{
					// If it is a map, it should contain the attribute "pattern".
					var patternValue:Null<Dynamic> = content.get("pattern");

					/**
					 * The value of "pattern" attribute should be any of the following:
					 * - null
					 * - a list of elements
					 * - a map i.e. a single element (to be considered if it should be allowed)
					 * - a pattern name
					 */
					if (patternValue == null)
						NULL_PATTERN;
					else if (isSequence(patternValue))
					{
						var element = PatternParser.parseAndFoldElements(patternValue);	// Interpret as a list of elements.

						if (element != NULL_ELEMENT) new Pattern("anonymous", element);
						else NULL_PATTERN;
					}
					else if (isMap(patternValue))
					{
						var element = ElementParser.parseElement(patternValue);	// Interpret as a single element.

						if (element != NULL_ELEMENT) new Pattern("anonymous", element);
						else NULL_PATTERN;
					}
					else
						PatternParser.parsePattern(cast(patternValue, String));	// Interpret as a string as it may be a pattern name.
				}
				else
					PatternParser.parsePattern(cast(content, String));	// Interpret as a string as it may be a pattern name.
			}
		}
		catch (unknown:Dynamic)
		{
			pattern = NULL_PATTERN;
		}

		return new Fire(pattern);
	}
}

package bloc.parser;

import bloc.element.Element;
import bloc.element.IfBranch;
import bloc.parser.ParserUtility.*;
import bloc.Utility.*;

class IfParser
{
	/**
	 * Parses the content of <if> element.
	 *
	 * @param   content The content of <if> element. This should be a map of the following attributes:
	 *     "expression" (String),
	 *     "command" (String),
	 *     "then" (pattern),
	 *     "else" (pattern).
	 *     The patterns can be either named or anonymous.
	 *     Each attribute is nullable, but the following must be non-null and valid.
	 *     (1) either one of "expression" or "command".
	 *     (2) either one of "then" or "else".
	 *     This format will be checked in this method.
	 * @return  The parsed <if> element instance.
	 */
	public static inline function parse(content:Dynamic):Element
	{
		var parsedElement:Element;

		try
		{
			if (!isMap(content))
				throw "Invalid content. The following object must be a mapping of attributes: " + content;

			var expression:Null<Dynamic> = content.get("expression");

			if (expression != null && !isString(expression))
			{
				throw "Invalid \"expression\" attribute. This must be a string: " + expression;
				expression = null;
			}

			var command:Null<Dynamic> = content.get("command");

			if (command != null && !isString(command))
			{
				throw "Invalid \"command\" attribute. This must be a string: " + expression;
				command = null;
			}

			var thenPattern = PatternParser.parsePatternContent(content.get("then"));
			var elsePattern = PatternParser.parsePatternContent(content.get("else"));

			if (expression == null && command == null)
				throw "Found neither \"expression\" nor \"command\" attribute.";

			if (thenPattern == NULL_PATTERN && elsePattern == NULL_PATTERN)
				throw "Found neither \"then\" nor \"else\" attribute.";

			parsedElement = new IfBranch(
			  expression,
			  command,
			  thenPattern,
			  elsePattern
			);
		}
		catch (message:String)
		{
			trace("[BLOC] Warning: Element <if>: " + message);
			parsedElement = NULL_ELEMENT;
		}

		return parsedElement;
	}
}
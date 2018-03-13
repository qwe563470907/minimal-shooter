package bloc.parser;

import bloc.element.IfBranch;
import bloc.parser.ParserUtility.*;

class IfParser
{
	public static inline function parse(content:Dynamic)
	{
		/**
		 * The content should be a map of the following attributes:
		 * - expression (String)
		 * - command (String)
		 * - then
		 * - else
		 * Each attribute is nullable.
		 */

		var expression:Null<Dynamic> = content.get("expression");

		if (expression != null && !isString(expression))
		{
			trace("[BLOC] Warning: Element <if>: The expression must be a string.");
			expression = null;
		}

		var command:Null<Dynamic> = content.get("command");

		if (command != null && !isString(command))
		{
			trace("[BLOC] Warning: Element <if>: \"command\" attribute must be a string.");
			command = null;
		}

		var nonParsedThenElements:Null<Dynamic> = content.get("then");
		var nonParsedElseElements:Null<Dynamic> = content.get("else");

		return if (expression == null && command == null)
		{
			trace("[BLOC] Warning: Element <if>: Found neither expression nor command.");
			Utility.NULL_ELEMENT;
		}
		else
			new IfBranch(
			  expression,
			  command,
			  PatternParser.parsePatternContent(nonParsedThenElements),
			  PatternParser.parsePatternContent(nonParsedElseElements)
			);
	}
}
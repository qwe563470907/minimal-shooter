package bloc.parser;

import bloc.element.*;
import bloc.element.ElementUtility.ElementName;
import bloc.parser.Parser.NonParsedElement;

class ElementParser
{
	static public function parseElement(nonParsedNode:Dynamic):Element
	{
		var parsedElement:Element;

		if (Std.is(nonParsedNode, NonParsedElement))
		{
			var element:NonParsedElement = cast nonParsedNode;
			var nameStr:String;

			try
			{ nameStr = getFirstKey(element); }
			catch (message:String)
			{
				trace(message);
				return Utility.NULL_ELEMENT;
			}

			var content = element.get(nameStr);

			var elementName = ParserUtility.stringToEnum(nameStr, "element", ElementName, "element", null_element);

			parsedElement = switch (elementName)
			{
				case position_element, velocity_element, shot_position_element, shot_velocity_element:
					VectorParser.parse(elementName, content);

				case fire_element:
					trace(nameStr);
					var argumentMap = element.get(nameStr);

					if (argumentMap == null)
					{
						new Fire(Utility.NULL_PATTERN)
					}
					else
					{
						var elements:Null<Array<NonParsedElement>> = argumentMap.get("pattern");
						var pattern = if (elements == null) Utility.NULL_PATTERN else new Pattern("anonymous", PatternParser.parseAndFoldElements(elements));

						new Fire(pattern);
					}

				case wait_element:
					var argument:Int = element.get(nameStr);
					trace(nameStr + " " + argument);
					new Wait(argument);

				case sequence_element:
					trace(nameStr);
					new Sequence(PatternParser.parseElementArray(element.get(nameStr)));

				case parallel_element:
					trace(nameStr);
					new Parallel(PatternParser.parseElementArray(element.get(nameStr)));

				case endless_element:
					trace(nameStr);
					new EndlessRepeat(PatternParser.parseAndFoldElements(element.get(nameStr)));

				case if_element:
					trace(nameStr);
					var argumentMap = element.get(nameStr);

					var expression = argumentMap.get("expression");

					if (expression != null && Std.is(expression, String) != true)
					{
						trace("[BLOC] Warning: The expression of <if> element must be a string.");
						expression = null;
					}

					var command = argumentMap.get("command");

					if (command != null && Std.is(command, String) != true)
					{
						trace("[BLOC] Warning: The command of <if> element must be a string.");
						command = null;
					}

					var nonParsedThenElements = argumentMap.get("then");

					if (nonParsedThenElements == null)
						nonParsedThenElements = [];
					else if (Std.is(nonParsedThenElements, Array) != true)
					{
						trace("[BLOC] Warning: \"then\" of <if> element must be a list of elements.");
						nonParsedThenElements = [];
					}

					var nonParsedElseElements = argumentMap.get("else");

					if (nonParsedElseElements == null)
						nonParsedElseElements = [];
					else if (Std.is(nonParsedElseElements, Array) != true)
					{
						trace("[BLOC] Warning: \"else\" of <if> element must be a list of elements.");
						nonParsedElseElements = [];
					}

					if (expression == null && command == null)
					{
						trace("[BLOC] Warning: <if> element must have either an expression or a command.");
						Utility.NULL_ELEMENT;
					}
					else
						new IfBranch(
						  expression,
						  command,
						  PatternParser.parseAndFoldElements(nonParsedThenElements),
						  PatternParser.parseAndFoldElements(nonParsedElseElements)
						);

				default:
					// definition?
					Utility.NULL_ELEMENT;
			}
		}
		else if (Std.is(nonParsedNode, String))
		{
			var patternName:String = cast(nonParsedNode, String);

			if (Parser.nonParsedPatternMap.exists(patternName))
			{
				trace("Found pattern alias " + patternName);
				parsedElement = PatternParser.parsePattern(patternName);
			}
			else
			{
				trace("[BLOC] No pattern found for alias " + patternName);
				parsedElement = Utility.NULL_ELEMENT;
			}
		}
		else
		{
			trace("[BLOC] Following object should be a map or string:\n" + nonParsedNode);
			parsedElement = Utility.NULL_ELEMENT;
		}

		if (parsedElement == null || !Std.is(parsedElement, Element))
		{
			trace("[BLOC] Failed to parse element:\n" + nonParsedNode);
			return Utility.NULL_ELEMENT;
		}

		return parsedElement;
	}

	static private function getFirstKey(object:NonParsedElement):String
	{
		if (!Std.is(object, NonParsedElement))
			throw "[BLOC] Following object should be a map:\n" + object.toString();

		var keys = object.keys();

		if (keys == null)
			throw "[BLOC] Error: Expected a mapping but received object without keys.";

		if (!keys.hasNext())
			throw "[BLOC] Error: Found an empty mapping.";

		return keys.next();
	}
}

package bloc.parser;

import bloc.element.*;

import bloc.parser.Parser.NonParsedElement;

class ElementParser
{
	static public function parseElement(nonParsedNode:Dynamic):Element
	{
		var parsedElement:Element;

		if (Std.is(nonParsedNode, NonParsedElement))
		{
			var element:NonParsedElement = cast nonParsedNode;
			var name:String;

			try
			{ name = getFirstKey(element); }
			catch (message:String)
			{
				trace(message);
				return Utility.NULL_ELEMENT;
			}

			parsedElement = switch (name)
			{
				case "fire":
					var argumentMap = element.get(name);
					var elements:Array<NonParsedElement> = argumentMap.get("pattern");
					trace(name);
					new Fire(new Pattern("anonymous", PatternParser.parseAndFoldElements(elements)));

				case "wait":
					var argument:Int = element.get(name);
					trace(name + " " + argument);
					new Wait(argument);

				case "addvelocity":
					var arguments:Array<Float> = element.get(name);
					trace(name + " [" + arguments[0] + ", " + arguments[1] + "]");
					new AddVelocity(new Vector().setPolar(arguments[0], arguments[1]));

				case "setvelocity":
					var arguments:Array<Float> = element.get(name);
					trace(name + " [" + arguments[0] + ", " + arguments[1] + "]");
					new SetVelocity(new Vector().setPolar(arguments[0], arguments[1]));

				case "shot_velocity":
					var argumentMap = element.get(name);
					var value = argumentMap.get("value");

					if (!Std.is(value, Array)) return Utility.NULL_ELEMENT;

					var coords = argumentMap.get("coordinates");
					var operation = argumentMap.get("operation");
					ShotVelocity.create(value, coords, operation);

				case "sequence":
					trace(name);
					new Sequence(PatternParser.parseElementArray(element.get(name)));

				case "parallel":
					trace(name);
					new Parallel(PatternParser.parseElementArray(element.get(name)));

				case "endless":
					trace(name);
					new EndlessRepeat(PatternParser.parseAndFoldElements(element.get(name)));

				case "if":
					trace(name);
					var argumentMap = element.get(name);

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

package bloc;

import yaml.Yaml;
import yaml.util.ObjectMap;
import openfl.Assets.getText;
import bloc.element.*;

typedef NonParsedElement = TObjectMap<String, Dynamic>;
typedef NonParsedElementArrayMap = TObjectMap<String, Array<Dynamic>>;

class Parser
{
	static private var _parsingPatternNameSet = new Map<String, Bool>();
	static private var _patternDictionary:Map<String, Pattern>;
	static private var _nonParsedPatternMap:NonParsedElementArrayMap;

	static public function parseYaml(filePath:String, patternDictionary:Map<String, Pattern>):Void
	{
		_patternDictionary = patternDictionary;

		var data:AnyObjectMap = Yaml.parse(getText(filePath));
		var patterns = data.get("patterns");

		if (patterns != null)
		{
			if (!Std.is(patterns, NonParsedElementArrayMap))
				throw "Error while parsing YAML:The content of \"patterns\" is invalid.";

			trace("Parsing file " + filePath);
			_nonParsedPatternMap = patterns;

			for (key in _nonParsedPatternMap.keys())
			{
				var patternName:String = cast(key, String);
				parsePattern(patternName);
			}
		}
	}

	static private function parsePattern(patternName:String):Pattern
	{
		if (_patternDictionary.exists(patternName))	// Already parsed
			return _patternDictionary.get(patternName);

		if (_parsingPatternNameSet.exists(patternName))
		{
			trace("[BLOC] Circular reference of pattern " + patternName);
			return Utility.NULL_PATTERN;
		}

		_parsingPatternNameSet.set(patternName, true);
		trace("Parsing " + patternName);

		var topElements = _nonParsedPatternMap.get(patternName);

		if (topElements == null)
		{
			trace("[BLOC] Pattern \"" + patternName + "\" has no content.");
			return Utility.NULL_PATTERN;
		}

		var parsedElement = foldElements(parseElementArray(topElements));
		var parsedPattern = new Pattern(patternName, parsedElement);

		_patternDictionary.set(patternName, parsedPattern);
		trace("[" + patternName + "]\n" + parsedPattern.render());
		_parsingPatternNameSet.remove(patternName);

		return parsedPattern;
	}

	static private function parseElement(nonParsedNode:Dynamic):Element
	{
		var parsedElement:Element;

		if (Std.is(nonParsedNode, NonParsedElement))
		{
			var element:NonParsedElement = cast nonParsedNode;
			var name = getFirstKey(element);

			parsedElement = switch (name)
			{
				case "fire":
					var arguments:Array<Float> = element.get(name);
					trace(name + " [" + arguments[0] + ", " + arguments[1] + "]");
					new Fire(arguments[0], arguments[1]);

				case "wait":
					var argument:Int = element.get(name);
					trace(name + " " + argument);
					new Wait(argument);

				case "addvelocity":
					var arguments:Array<Float> = element.get(name);
					trace(name + " [" + arguments[0] + ", " + arguments[1] + "]");
					new AddVelocity(arguments[0], arguments[1]);

				case "setvelocity":
					var arguments:Array<Float> = element.get(name);
					trace(name + " [" + arguments[0] + ", " + arguments[1] + "]");
					new SetVelocity(arguments[0], arguments[1]);

				case "sequence":
					trace(name);
					new Sequence(parseElementArray(element.get(name)));

				case "parallel":
					trace(name);
					new Parallel(parseElementArray(element.get(name)));

				case "endless":
					trace(name);
					new EndlessRepeat(foldElements(parseElementArray(element.get(name))));

				case "if":
					trace(name);
					var argumentMap = element.get(name);
					var expression = argumentMap.get("expression");
					var nonParsedThenElements:Array<Element> = argumentMap.get("then");

					if (nonParsedThenElements == null) nonParsedThenElements = [];

					var nonParsedElseElements:Array<Element> = argumentMap.get("else");

					if (nonParsedElseElements == null) nonParsedElseElements = [];

					if (expression == null)
					{
						trace("[BLOC] Warning: <if> element without expression.");
						Utility.NULL_ELEMENT;
					}
					else if (Std.is(expression, String) == false)
					{
						trace("[BLOC] Warning: <if> element must have a string expression.");
						Utility.NULL_ELEMENT;
					}
					else
						new IfBranch(
						  expression,
						  foldElements(parseElementArray(nonParsedThenElements)),
						  foldElements(parseElementArray(nonParsedElseElements))
						);

				default:
					// definition?
					Utility.NULL_ELEMENT;
			}
		}
		else if (Std.is(nonParsedNode, String))
		{
			var patternName:String = cast(nonParsedNode, String);

			if (_nonParsedPatternMap.exists(patternName))
			{
				trace("Found pattern alias " + patternName);
				parsedElement = parsePattern(patternName);
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

	static private function foldElements(elements:Array<Element>):Element
	{
		if (elements.length == 0) return Utility.NULL_ELEMENT;

		if (elements.length == 1) return elements[0];

		return new Sequence(elements);
	}

	static private function parseElementArray(nonParsedElements:Array<Dynamic>):Array<Element>
	{
		var parsedElements:Array<Element> = [];

		for (e in nonParsedElements)
			parsedElements.push(parseElement(e));

		return parsedElements;
	}

	static private function getFirstKey(object:NonParsedElement):String
	{
		if (!Std.is(object, NonParsedElement))
		{
			trace("[BLOC] Following object should be a map:" + object);
			throw "[BLOC] Error:Invalid object.";
		}

		var keys = object.keys();

		if (keys == null)
			throw "[BLOC] Error:Expected a mapping but received object without keys.";

		if (!keys.hasNext())
			throw "[BLOC] Error:Found an empty mapping.";

		return keys.next();
	}
}

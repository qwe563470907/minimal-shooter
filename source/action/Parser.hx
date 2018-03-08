package action;

import yaml.Yaml;
import yaml.util.ObjectMap;
import openfl.Assets.getText;
import action.element.*;

typedef NonParsedElement = TObjectMap<String, Dynamic>;
typedef NonParsedElementArrayMap = TObjectMap<String, Array<Dynamic>>;

class Parser
{
	static private var _parsingPatternNameSet = new Map<String, Bool>();
	static private var _patternDictionary: Map<String, Element>;
	static private var _nonParsedPatternMap: NonParsedElementArrayMap;

	static public function parseYaml(filePath: String, patternDictionary: Map<String, Element>): Void
	{
		_patternDictionary = patternDictionary;

		var data: AnyObjectMap = Yaml.parse(getText(filePath));
		var patterns = data.get("patterns");

		if (patterns != null)
		{
			if (!Std.is(patterns, NonParsedElementArrayMap))
				throw "Error while parsing YAML: The content of \"patterns\" is invalid.";

			trace("Parsing file " + filePath);
			_nonParsedPatternMap = patterns;

			for (key in _nonParsedPatternMap.keys())
			{
				var patternName: String = cast(key, String);
				parsePattern(patternName);
			}
		}
	}

	static private function parsePattern(patternName: String): Element
	{
		if (_patternDictionary.exists(patternName))
			return _patternDictionary.get(patternName);

		_parsingPatternNameSet.set(patternName, true);
		trace("Parsing " + patternName);

		var topElements = _nonParsedPatternMap.get(patternName);

		if (topElements == null)
			throw "Error: pattern \"" + patternName + "\" has no content.";

		var parsedElement = foldElements(parseElementArray(topElements));
		parsedElement.name = patternName;

		_patternDictionary.set(patternName, parsedElement);
		trace("[" + patternName + "]\n" + parsedElement);
		_parsingPatternNameSet.remove(patternName);

		return parsedElement;
	}

	static private function parseElement(nonParsedNode: Dynamic): Element
	{
		trace("Begin parseElement");

		var parsedElement: Element;

		if (Std.is(nonParsedNode, NonParsedElement))
		{
			trace("Parcing a new element");
			var element: NonParsedElement = cast nonParsedNode;
			var name = getFirstKey(element);
			trace("Parcing element " + name);

			parsedElement = switch (name)
			{
				case "fire":
					var arguments: Array<Float> = element.get(name);
					trace(name + " [" + arguments[0] + ", " + arguments[1] + "]");
					new Fire(arguments[0], arguments[1]);

				case "wait":
					var argument: Int = element.get(name);
					trace(name + " " + argument);
					new Wait(argument);

				case "addvelocity":
					var arguments: Array<Float> = element.get(name);
					trace(name + " [" + arguments[0] + ", " + arguments[1] + "]");
					new AddVelocity(arguments[0], arguments[1]);

				case "setvelocity":
					var arguments: Array<Float> = element.get(name);
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

				default:
					// definition?
					new NullElement();
			}
		}
		else if (Std.is(nonParsedNode, String))
		{
			var patternName: String = cast(nonParsedNode, String);
			trace("Found pattern alias " + patternName);

			if (_nonParsedPatternMap.exists(patternName))
				parsedElement = parsePattern(patternName);
			else
			{
				trace("No pattern found for alias " + patternName);
				parsedElement = new NullElement();
			}
		}
		else
		{
			trace("Neither Map nor String");
			parsedElement = new NullElement();
		}

		if (parsedElement == null || !Std.is(parsedElement, Element))
		{
			trace("Failed to parse element:\n" + nonParsedNode);
			return new NullElement();
		}

		return parsedElement;
	}

	static private function foldElements(elements: Array<Element>): Element
	{
		if (elements.length == 1) return elements[0];

		return new Sequence(elements);
	}

	static private function parseElementArray(nonParsedElements: Array<Dynamic>): Array<Element>
	{
		var parsedElements: Array<Element> = [];

		for (e in nonParsedElements)
			parsedElements.push(parseElement(e));

		return parsedElements;
	}

	static private function getFirstKey(object: NonParsedElement): String
	{
		if (!Std.is(object, NonParsedElement))
		{
			trace(object + " should be a map.");
			throw "Error while parsing BLOC";
		}

		var keys = object.keys();

		if (keys == null)
			throw "Error while parsing BLOC: Expected a mapping but received object without keys.";

		if (!keys.hasNext())
			throw "Error while parsing BLOC: Found an empty mapping.";

		return keys.next();
	}
}

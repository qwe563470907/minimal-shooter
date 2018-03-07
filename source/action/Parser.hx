package action;

import yaml.Yaml;
import yaml.util.ObjectMap;
import openfl.Assets.getText;
import action.element.*;

typedef NonParsedElement = TObjectMap<String, Dynamic>;
typedef NonParsedCollectionElement = TObjectMap<String, Array<NonParsedElement>>;

class Parser
{
	static public function parseYaml(filePath: String): Map<String, Element>
	{
		var data: AnyObjectMap = Yaml.parse(getText(filePath));
		var patterns: NonParsedCollectionElement = data.get("patterns");
		var patternDictionary = new Map<String, Element>();

		if (patterns != null)
		{
			for (patternName in patterns.keys())
			{
				trace("Parsing " + patternName);
				var topElements: Array<NonParsedElement> = patterns.get(patternName);
				var parsedElement = foldElements(parseElementArray(topElements));
				parsedElement.name = patternName;
				patternDictionary.set(patternName, parsedElement);
				trace("[" + patternName + "]\n" + parsedElement);
			}
		}

		return patternDictionary;
	}

	static public function parseElement(nonParsedElement: NonParsedElement): Element
	{
		if (Std.is(nonParsedElement, TObjectMap))
		{
			var name = getFirstKey(nonParsedElement);

			return switch (name)
			{
				case "fire":
					var arguments: Array<Float> = nonParsedElement.get(name);
					trace(name + " [" + arguments[0] + ", " + arguments[1] + "]");
					new Fire(arguments[0], arguments[1]);

				case "wait":
					var argument: Int = nonParsedElement.get(name);
					trace(name + " " + argument);
					new Wait(argument);

				case "addvelocity":
					var arguments: Array<Float> = nonParsedElement.get(name);
					trace(name + " [" + arguments[0] + ", " + arguments[1] + "]");
					new AddVelocity(arguments[0], arguments[1]);

				case "setvelocity":
					var arguments: Array<Float> = nonParsedElement.get(name);
					trace(name + " [" + arguments[0] + ", " + arguments[1] + "]");
					new SetVelocity(arguments[0], arguments[1]);

				case "sequence":
					trace(name);
					new Sequence(parseElementArray(nonParsedElement.get(name)));

				case "parallel":
					trace(name);
					new Parallel(parseElementArray(nonParsedElement.get(name)));

				case "endless":
					trace(name);
					new EndlessRepeat(foldElements(parseElementArray(nonParsedElement.get(name))));

				default:
					new NullElement();
			}
		}

		return new NullElement();
	}

	static private function foldElements(elements: Array<Element>): Element
	{
		if (elements.length == 1) return elements[0];

		return new Sequence(elements);
	}

	static private function parseElementArray(nonParsedElements: Array<NonParsedElement>): Array<Element>
	{
		var parsedElements: Array<Element> = [];

		for (e in nonParsedElements)
			parsedElements.push(parseElement(e));

		return parsedElements;
	}

	static private function getFirstKey(object: NonParsedElement): String
	{
		var keys = object.keys();

		if (keys == null)
			throw "Error while parsing YAML: Expected a mapping but received object without keys.";

		if (!keys.hasNext())
			throw "Error while parsing YAML: Found an empty mapping.";

		return keys.next();
	}
}

package bloc.parser;

import bloc.Utility.NULL_ELEMENT;
import bloc.Utility.NULL_PATTERN;
import bloc.element.Element;
import bloc.element.Sequence;

class PatternParser
{
	static private var _parsingPatternNameSet = new Map<String, Bool>();

	static public function parseElementArray(nonParsedElements:Array<Dynamic>):Array<Element>
	{
		var parsedElements:Array<Element> = [];

		for (e in nonParsedElements)
		{
			var parsedElement = ElementParser.parseElement(e);

			if (parsedElement != NULL_ELEMENT) parsedElements.push(parsedElement);
		}

		return parsedElements;
	}

	static public function parseAndFoldElements(nonParsedElements:Array<Dynamic>):Element
	{
		return foldElements(parseElementArray(nonParsedElements));
	}

	static public function parsePattern(patternName:String):Pattern
	{
		// Check if already parsed
		if (Parser.patternDictionary.exists(patternName))
			return Parser.patternDictionary.get(patternName);

		// Check circular reference
		if (_parsingPatternNameSet.exists(patternName))
		{
			trace("[BLOC] Warning: Circular reference of pattern " + patternName);
			return NULL_PATTERN;
		}

		// Check if the pattern exists
		if (!Parser.nonParsedPatternMap.exists(patternName))
		{
			trace("[BLOC] Warning: Could not find pattern \"" + patternName + "\".");
			return NULL_PATTERN;
		}

		// Get & check contents
		var topElements = Parser.nonParsedPatternMap.get(patternName);

		if (topElements == null)
		{
			trace("[BLOC] Warning: Pattern \"" + patternName + "\" has no content.");
			return NULL_PATTERN;
		}

		// Parse contents
		_parsingPatternNameSet.set(patternName, true);
		trace("Parsing " + patternName);
		var parsedElement = parseAndFoldElements(topElements);

		// Complete parsing
		var parsedPattern = new Pattern(patternName, parsedElement);
		Parser.patternDictionary.set(patternName, parsedPattern);
		trace("[" + patternName + "]\n" + parsedPattern.render());
		_parsingPatternNameSet.remove(patternName);

		return parsedPattern;
	}

	static private function foldElements(elements:Array<Element>):Element
	{
		if (elements.length == 0) return NULL_ELEMENT;

		if (elements.length == 1) return elements[0];

		return new Sequence(elements);
	}
}
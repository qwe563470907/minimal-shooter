package bloc.parser;

import bloc.element.Element;
import bloc.element.Sequence;

class PatternParser
{
	static private var _parsingPatternNameSet = new Map<String, Bool>();

	static public function parseElementArray(nonParsedElements:Array<Dynamic>):Array<Element>
	{
		var parsedElements:Array<Element> = [];

		for (e in nonParsedElements)
			parsedElements.push(ElementParser.parseElement(e));

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
			trace("[BLOC] Circular reference of pattern " + patternName);
			return Utility.NULL_PATTERN;
		}

		// Get & check contents
		var topElements = Parser.nonParsedPatternMap.get(patternName);

		if (topElements == null)
		{
			trace("[BLOC] Pattern \"" + patternName + "\" has no content.");
			return Utility.NULL_PATTERN;
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
		if (elements.length == 0) return Utility.NULL_ELEMENT;

		if (elements.length == 1) return elements[0];

		return new Sequence(elements);
	}
}
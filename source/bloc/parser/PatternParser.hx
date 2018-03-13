package bloc.parser;

import bloc.Utility.NULL_ELEMENT;
import bloc.Utility.NULL_PATTERN;
import bloc.element.Element;
import bloc.element.Sequence;

class PatternParser
{
	static private var _parsingPatternNameSet = new Map<String, Bool>();

	/**
	 * Parses the pattern extracted from BLOC file and stores the result in Parser class.
	 *
	 * @param   patternName The name of the pattern written in BLOC file.
	 * @return  The parsed pattern instance.
	 */
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

		// Get & parse contents
		trace("[BLOC] Log: Parsing pattern \"" + patternName + "\".");
		_parsingPatternNameSet.set(patternName, true);
		var content = Parser.nonParsedPatternMap.get(patternName);
		var parsedPattern = parsePatternContent(content, patternName);

		// Complete parsing
		Parser.patternDictionary.set(patternName, parsedPattern);
		_parsingPatternNameSet.remove(patternName);
		trace("[BLOC] Log: Parsed pattern \"" + patternName + "\":\n" + parsedPattern.renderElements());

		return parsedPattern;
	}

	/**
	 * Parses the content of a pattern extracted from BLOC file.
	 *
	 * @param   content The content of a pattern before parsing. Expected to be any of null, a list of elements or a pattern name.
	 * @param   patternName (Optional) The name of the pattern written in BLOC file. Can be omitted if the pattern is anonymous.
	 * @return  The parsed pattern instance.
	 */
	static public inline function parsePatternContent(content:Null<Dynamic>, ?patternName:Null<String>):Pattern
	{

		return if (content == null)
		{
			if (patternName != null) new Pattern.NamedPattern(patternName, NULL_ELEMENT);
			else NULL_PATTERN;
		}
		else if (ParserUtility.isSequence(content))
		{
			var element = parseAndFoldElements(content);	// Interpret as a list of elements.

			if (element != NULL_ELEMENT)
			{
				if (patternName != null) new Pattern.NamedPattern(patternName, element);
				else new Pattern.AnonymousPattern(element);
			}
			else NULL_PATTERN;
		}
		else
		{
			var parsedPattern = parsePattern(cast content);	// Interpret as a string as it may be a pattern name.

			if (patternName != null && parsedPattern != NULL_PATTERN) new Pattern.NamedPattern(patternName, parsedPattern);
			else parsedPattern;
		}
	}

	/**
	 * Parses an array of non-parsed elements.
	 *
	 * @param   nonParsedElements The array of non-parsed elements.
	 * @return  The array of parsed element instances.
	 */
	static public inline function parseElementArray(nonParsedElements:Array<Dynamic>):Array<Element>
	{
		var parsedElements:Array<Element> = [];

		for (e in nonParsedElements)
		{
			var parsedElement = ElementParser.parseElement(e);

			if (parsedElement != NULL_ELEMENT) parsedElements.push(parsedElement);
		}

		return parsedElements;
	}

	/**
	 * Parses an array of non-parsed elements and fold them to a single element instance.
	 * If the parsing result is an array of multiple elements, they will be folded as a single <sequence> element.
	 *
	 * @param   nonParsedElements The array of non-parsed elements.
	 * @return  The parsed and folded element instance.
	 */
	static public inline function parseAndFoldElements(nonParsedElements:Array<Dynamic>):Element
	{
		return foldElements(parseElementArray(nonParsedElements));
	}

	static private inline function foldElements(elements:Array<Element>):Element
	{

		return switch (elements.length)
		{
			case 0: NULL_ELEMENT;

			case 1: return elements[0];

			default: new Sequence(elements);
		}
	}
}
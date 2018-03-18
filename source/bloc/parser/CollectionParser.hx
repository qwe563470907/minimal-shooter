package bloc.parser;

import bloc.element.Element;
import bloc.element.Sequence;
import bloc.element.Parallel;
import bloc.element.Async;
import bloc.element.Endless;
import bloc.element.ElementUtility;
import bloc.parser.ParserUtility.isSequence;

class CollectionParser
{
	static public inline function parse(elementName:ElementName, content: Null<Dynamic>):Element
	{
		if (!isSequence(content))
			throw "Following object must be a list of elements:\n" + content;

		var elements = PatternParser.parseElementArray(content);

		return switch (elementName)
		{
			case sequence_element: new Sequence(elements);

			case parallel_element: new Parallel(elements);

			case endless_element:
				var endlessPattern = new Endless(elements);

				if (!endlessPattern.containsWait()) throw "Contains no element which takes one or more frames.";

				endlessPattern;

			default: throw "Passed invalid element. Maybe a bug.";
		}
	}
}
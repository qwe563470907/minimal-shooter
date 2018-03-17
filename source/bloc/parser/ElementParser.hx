package bloc.parser;

import bloc.element.*;
import bloc.element.ElementUtility.ElementName;
import bloc.parser.Parser.NonParsedElement;
import bloc.parser.ParserUtility.*;
import bloc.Utility.NULL_ELEMENT;

class ElementParser
{
	/**
	 * Parses the single element extracted from BLOC file.
	 *
	 * @param   nonParsedElement The element before parsing. Expected to be either a mapping with a single key-value pair or a pattern name (will be validated in this method).
	 * @return  The parsed element instance.
	 */
	static public inline function parseElement(nonParsedElement:Null<Dynamic>):Element
	{
		var parsedElement:Element;

		try
		{
			if (nonParsedElement == null)
				parsedElement = NULL_ELEMENT;
			else if (isMap(nonParsedElement))
			{
				var elementNameString = getFirstKey(nonParsedElement);	// Interpret as a mapping with a single key-value pair.
				var content = nonParsedElement.get(elementNameString);
				var elementName = ParserUtility.stringToEnum(elementNameString, "element", ElementName, "element", null_element);

				parsedElement = parseElementContent(elementName, elementNameString, content);
			}
			else
			{
				var patternName:String = cast nonParsedElement;	// Interpret as a string as it may be a pattern name.
				parsedElement = PatternParser.parsePattern(patternName);
			}

			if (parsedElement == null || !Std.is(parsedElement, Element))
				throw "Failed to parse element:\n" + nonParsedElement;
		}
		catch (message:String)
		{
			trace("[BLOC] Warning: Invalid element. " + message);
			parsedElement = NULL_ELEMENT;
		}

		return parsedElement;
	}

	static private inline function parseElementContent(elementName:ElementName, elementNameString:String, content:Null<Dynamic>):Element
	{
		var parsedElement:Element;

		try
		{

			parsedElement = switch (elementName)
			{
				case position_element, velocity_element, shot_position_element, shot_velocity_element:
					VectorParser.parse(elementName, content);

				case distance_element, bearing_element, speed_element, direction_element,
						shot_distance_element, shot_bearing_element, shot_speed_element, shot_direction_element,
						bearing_angular_velocity_element, direction_angular_velocity_element,
						shot_bearing_angular_velocity_element, shot_direction_angular_velocity_element:
					ScalarParser.parse(elementName, content);

				case fire_element:
					FireParser.parse(content);

				case wait_element:
					if (isInt(content)) new Wait(content);
					else if (isFloat(content)) new Wait(Math.floor(content));
					else throw "Passed a non-number value: " + content;

				case sequence_element:
					if (isSequence(content)) new Sequence(PatternParser.parseElementArray(content));
					else throw "Following object must be a list of elements:\n" + content;

				case parallel_element:
					if (isSequence(content)) new Parallel(PatternParser.parseElementArray(content));
					else throw "Following object must be a list of elements:\n" + content;

				case loop_element:
					LoopParser.parse(content);

				case endless_element:
					if (isSequence(content))
					{
						var pattern = new Endless(PatternParser.parseElementArray(content));

						if (!pattern.containsWait()) throw "Contains no element which takes one or more frames.";

						pattern;
					}
					else throw "Following object must be a list of elements:\n" + content;

				case if_element:
					IfParser.parse(content);

				case command_element:
					if (isString(content)) new SendCommand(content);
					else throw "Following must be a string:\n" + content;

				default:
					// definition?
					NULL_ELEMENT;
			}
		}
		catch (message:String)
		{
			trace("[BLOC] Warning: Element <" + elementNameString + ">: Invalid content. " + message);
			parsedElement = NULL_ELEMENT;
		}

		return parsedElement;
	}

	static private function getFirstKey(object:NonParsedElement):String
	{
		var keys = object.keys();

		if (keys == null)
			throw "Expected a mapping but received object without keys:\n" + object.toString();

		if (!keys.hasNext())
			throw "Found an empty mapping.";

		var firstKey = keys.next();

		if (keys.hasNext())
			throw "Multiple key-value pairs for a single element:\n" + object.toString();

		return firstKey;
	}
}

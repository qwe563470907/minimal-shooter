package bloc.parser;

import yaml.Yaml;
import yaml.util.ObjectMap;
import openfl.Assets.getText;

typedef NonParsedElement = TObjectMap<String, Dynamic>;
typedef NonParsedElementArrayMap = TObjectMap<String, Array<Dynamic>>;

class Parser
{
	/**
	 * The map where the parsed patterns will be stored.
	 */
	static public var patternDictionary:Map<String, Pattern>;

	/**
	 * The map of non-parsed patterns. Will be newly assigned for every BLOC file and referred from other parser classes.
	 */
	static public var nonParsedPatternMap:NonParsedElementArrayMap;

	/**
	 * Parses the provided BLOC file (a YAML document) and stores the result.
	 *
	 * @param   filePath The file path of the BLOC file to parse.
	 */
	static public function parseYaml(filePath:String):Void
	{
		if (patternDictionary == null) patternDictionary = new Map<String, Pattern>();

		trace("[BLOC] Parsing file " + filePath);

		var data:AnyObjectMap = Yaml.parse(getText(filePath));

		var patterns = data.get("patterns");

		parsePatterns(patterns);
	}

	/**
	 * Parses the content of "patterns" section extracted from BLOC file and stores the result.
	 *
	 * @param   patterns The content of "patterns" section. Expected to be a mapping of pattern names and contents (will be checked in this method).
	 */
	static public function parsePatterns(patterns:Null<Dynamic>):Void
	{
		if (patterns != null)
		{
			if (ParserUtility.isMap(patterns))
			{
				nonParsedPatternMap = patterns;

				// Parse each pattern
				for (key in nonParsedPatternMap.keys())
				{
					var patternName:String = cast(key, String);
					PatternParser.parsePattern(patternName);
				}
			}
			else
				trace("[BLOC] Warning: The content of \"patterns\" is invalid.");
		}
	}
}

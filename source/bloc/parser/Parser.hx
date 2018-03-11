package bloc.parser;

import yaml.Yaml;
import yaml.util.ObjectMap;
import openfl.Assets.getText;

typedef NonParsedElement = TObjectMap<String, Dynamic>;
typedef NonParsedElementArrayMap = TObjectMap<String, Array<Dynamic>>;

class Parser
{
	static public var patternDictionary:Map<String, Pattern>;
	static public var nonParsedPatternMap:NonParsedElementArrayMap;

	static public function parseYaml(filePath:String):Void
	{
		if (patternDictionary == null) patternDictionary = new Map<String, Pattern>();

		trace("[BLOC] Parsing file " + filePath);

		var data:AnyObjectMap = Yaml.parse(getText(filePath));

		var patterns = data.get("patterns");

		if (patterns != null)
			parsePatterns(patterns);
	}

	static public function parsePatterns(patterns:Dynamic):Void
	{
		if (!Std.is(patterns, NonParsedElementArrayMap))
			throw "[BLOC] Error: The content of \"patterns\" is invalid.";

		nonParsedPatternMap = patterns;

		// Parse each pattern
		for (key in nonParsedPatternMap.keys())
		{
			var patternName:String = cast(key, String);
			PatternParser.parsePattern(patternName);
		}
	}
}

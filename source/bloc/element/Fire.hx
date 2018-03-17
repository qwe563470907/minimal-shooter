package bloc.element;

import bloc.Pattern;
import bloc.Utility.NULL_PATTERN;
import bloc.element.ElementUtility.indent;

class Fire extends DefaultElement
{
	private var _pattern:Pattern;
	private var _bind:Bool;

	public function new (pattern:Pattern, bind:Bool)
	{
		super();
		this._pattern = pattern;
		this._bind = bind;
	}

	override public inline function run(actor:Actor):Bool
	{
		actor.fire(this._pattern, this._bind);

		return true;
	}

	override public function toString():String
	{
		var patternStr = "";

		if (this._pattern != NULL_PATTERN) patternStr += ":\n" + indent(this._pattern.toString());

		return "fire" + patternStr;
	}
}

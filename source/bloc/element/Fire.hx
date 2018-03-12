package bloc.element;

import bloc.Pattern;

class Fire extends DefaultElement
{
	private var _pattern:Pattern;

	public function new (pattern:Pattern)
	{
		super();
		this._pattern = pattern;
	}

	override public inline function run(actor:Actor):Bool
	{
		actor.fire(this._pattern);

		return true;
	}

	override public function toString():String
	{
		return "fire";
	}
}

package bloc.element;

import bloc.Pattern;

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
		return "fire";
	}
}

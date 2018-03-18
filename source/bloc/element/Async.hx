package bloc.element;

import bloc.element.ElementUtility.indent;

class Async extends DefaultElement
{
	private var _pattern:Pattern;

	public function new (pattern:Pattern)
	{
		super();
		this._pattern = pattern;
	}

	override public inline function run(actor:Actor):Bool
	{
		this._pattern.resetState(actor);
		actor.addSubThreadPattern(this._pattern);

		return true;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		this._pattern.prepareState(manager);
	}

	override public inline function containsWait():Bool
	{
		return this._pattern.containsWait();
	}

	override public function toString():String
	{
		return "async:\n" + indent(this._pattern.toString());
	}
}

package bloc;

import bloc.element.Element;

/**
 * Composition of BLOC elements. A BLOC pattern can be also an element in another pattern.
 */
interface Pattern extends Element
{
	public var name(get, null):String;
	public function renderElements():String;
}

private class AbstractPattern implements Pattern
{
	public var name(get, null):String;

	public function new (name:String)
	{
		this.name = name;
	}

	public function run(actor:Actor):Bool
	{
		return true;
	}

	public function prepareState(manager:StateManager):Void
	{
	}

	public function resetState(actor:Actor):Void
	{
	}

	public function renderElements():String
	{
		return "no elements";
	}

	public function toString():String
	{
		return this.name;
	}

	public function containsWait():Bool
	{
		return false;
	}

	inline function get_name():String
	{
		return this.name;
	}
}

private class NonNullPattern extends AbstractPattern
{
	private var _topElement:Element;

	public function new (name:String, topElement:Element)
	{
		super(name);
		this._topElement = topElement;
	}

	override public inline function run(actor:Actor):Bool
	{
		return _topElement.run(actor);
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		_topElement.prepareState(manager);
	}

	override public inline function resetState(actor:Actor):Void
	{
		_topElement.resetState(actor);
	}

	override public inline function renderElements():String
	{
		return _topElement.toString();
	}

	override public inline function containsWait():Bool
	{
		return this._topElement.containsWait();
	}
}

class NamedPattern extends NonNullPattern
{
	public function new (name:String, topElement:Element)
	{
		super(name, topElement);
	}
}

class AnonymousPattern extends NonNullPattern
{
	public function new (topElement:Element)
	{
		super("anonymous pattern", topElement);
	}

	override public function toString():String
	{
		return this.renderElements();
	}
}

class NullPattern extends AbstractPattern
{
	public function new ()
	{
		super("null pattern");
	}
}

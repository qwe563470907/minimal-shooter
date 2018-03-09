package bloc;

import bloc.element.Element;

/**
 * Composition of BLOC elements. A BLOC pattern can be also an element in another pattern.
 */
class Pattern implements Element
{
	public var name:String = "";
	public var topElement:Element;

	public function new (name:String, topElement:Element)
	{
		this.name = name;
		this.topElement = topElement;
	}

	public function run(actor:Actor):Bool
	{
		return topElement.run(actor);
	}

	public function prepareState(manager:StateManager):Void
	{
		topElement.prepareState(manager);
	}

	public function resetState(actor:Actor):Void
	{
		topElement.resetState(actor);
	}

	public function toString():String
	{
		return name;
	}

	public function render():String
	{
		return topElement.toString();
	}
}

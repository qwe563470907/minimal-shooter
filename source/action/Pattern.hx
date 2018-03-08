package action;

import action.element.Element;

class Pattern implements Element
{
	public var name: String = "";
	public var topElement: Element;

	public function new (name: String, topElement: Element)
	{
		this.name = name;
		this.topElement = topElement;
	}

	public function run(actor: IActor): Bool
	{
		return topElement.run(actor);
	}

	public function prepareState(manager: StateManager): Void
	{
		topElement.prepareState(manager);
	}

	public function resetState(actor: IActor): Void
	{
		topElement.resetState(actor);
	}

	public function toString(): String
	{
		return name;
	}

	public function render(): String
	{
		return topElement.toString();
	}
}

package action.element;

import action.element.Element;

class DefaultElement implements Element
{
	public var name: String = "";

	private function new () {}

	public function run(actor: IActor): Bool
	{
		return true;
	}

	public function prepareState(manager: StateManager): Void
	{
	}

	public function resetState(actor: IActor): Void
	{
	}

	public function toString(): String
	{
		return "";
	}
}

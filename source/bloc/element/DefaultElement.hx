package bloc.element;

import de.polygonal.ds.HashableItem;

class DefaultElement extends HashableItem implements Element
{
	private function new ()
	{
		super();
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

	public function toString():String
	{
		return "";
	}

	public function containsWait():Bool
	{
		return false;
	}
}

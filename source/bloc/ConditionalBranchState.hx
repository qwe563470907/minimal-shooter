package bloc;

import bloc.element.Element;

class ConditionalBranchState implements State
{
	public var activeBranch(get, null):Null<Element>;

	public function new ()
	{
		reset();
	}

	public inline function reset():Void
	{
		this.activeBranch = null;
	}

	public inline function setActiveBranch(activeBranch:Element):Void
	{
		this.activeBranch = activeBranch;
	}

	inline function get_activeBranch()
	{
		return activeBranch;
	}
}

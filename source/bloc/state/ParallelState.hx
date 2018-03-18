package bloc.state;

import de.polygonal.ds.HashSet;
import bloc.element.Element;

class ParallelState implements State
{
	private var _completedElements:HashSet<Element>;

	public function new ()
	{
		this._completedElements = new HashSet<Element>(8, 8);
	}

	public inline function reset():Void
	{
		this._completedElements.clear();
	}

	public inline function setCompleted(element:Element):Void
	{
		this._completedElements.set(element);
	}

	public inline function hasCompleted(element:Element):Null<Bool>
	{
		return this._completedElements.has(element);
	}
}

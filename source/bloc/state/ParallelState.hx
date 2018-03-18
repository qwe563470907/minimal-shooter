package bloc.state;

import de.polygonal.ds.tools.ObjectPool;
import de.polygonal.ds.HashSet;
import bloc.element.Element;

class ParallelState implements State
{
	private static var _pool =
	{
		var pool = new ObjectPool<ParallelState>(function() { return new ParallelState(); });
		pool.preallocate(64);
		pool;
	}

	public static inline function get():ParallelState
	{ return ParallelState._pool.get(); }

	public static inline function put(state:ParallelState):Void
	{ ParallelState._pool.put(state); }


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

package bloc.state;

import de.polygonal.ds.tools.ObjectPool;
import bloc.element.Element;

class ConditionalBranchState implements State
{
	private static var _pool =
	{
		var pool = new ObjectPool<ConditionalBranchState>(function() { return new ConditionalBranchState(); });
		pool.preallocate(64);
		pool;
	}

	public static inline function get():ConditionalBranchState
	{ return ConditionalBranchState._pool.get(); }

	public static inline function put(state:ConditionalBranchState):Void
	{ ConditionalBranchState._pool.put(state); }


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

package bloc.state;

import de.polygonal.ds.tools.ObjectPool;

class FloatState implements State
{
	private static var _pool =
	{
		var pool = new ObjectPool<FloatState>(function() { return new FloatState(); });
		pool.preallocate(64);
		pool;
	}

	public static inline function get():FloatState
	{ return FloatState._pool.get(); }

	public static inline function put(state:FloatState):Void
	{ FloatState._pool.put(state); }


	public var value:Null<Float>;

	public function new ()
	{
		reset();
	}

	public inline function reset():Void
	{
		this.value = null;
	}
}

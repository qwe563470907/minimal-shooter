package bloc.state;

import de.polygonal.ds.tools.ObjectPool;

class VectorState implements State
{
	private static var _pool =
	{
		var pool = new ObjectPool<VectorState>(function() { return new VectorState(); });
		pool.preallocate(64);
		pool;
	}

	public static inline function get():VectorState
	{ return VectorState._pool.get(); }

	public static inline function put(state:VectorState):Void
	{ VectorState._pool.put(state); }


	public var value:Null<Vector>;

	public function new ()
	{
		reset();
	}

	public inline function reset():Void
	{
		this.value = null;
	}
}

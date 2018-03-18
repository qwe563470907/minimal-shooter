package bloc.state;

import de.polygonal.ds.tools.ObjectPool;

class AngleIntervalState implements State
{
	private static var _pool =
	{
		var pool = new ObjectPool<AngleIntervalState>(function() { return new AngleIntervalState(); });
		pool.preallocate(64);
		pool;
	}

	public static inline function get():AngleIntervalState
	{ return AngleIntervalState._pool.get(); }

	public static inline function put(state:AngleIntervalState):Void
	{ AngleIntervalState._pool.put(state); }


	public var value:Null<AngleInterval>;

	public function new ()
	{
		reset();
	}

	public inline function reset():Void
	{
		this.value = null;
	}
}

package bloc.state;

import de.polygonal.ds.tools.ObjectPool;

class CountState implements State
{
	private static var _pool =
	{
		var pool = new ObjectPool<CountState>(function() { return new CountState(); });
		pool.preallocate(64);
		pool;
	}

	public static inline function get():CountState
	{ return CountState._pool.get(); }

	public static inline function put(state:CountState):Void
	{ CountState._pool.put(state); }


	public var count(get, null):Int;
	public var isCompleted(get, null):Bool;
	public var maxCount(null, default):Int;

	public function new ()
	{
		this.maxCount = 0;
		this.reset();
	}

	public inline function increment():Void
	{
		this.count++;

		if (this.count >= this.maxCount) this.isCompleted = true;
	}

	public inline function reset():Void
	{
		this.count = 0;
		this.isCompleted = false;
	}

	public inline function get_count():Int
	{
		return this.count;
	}

	public inline function get_isCompleted():Bool
	{
		return this.isCompleted;
	}
}

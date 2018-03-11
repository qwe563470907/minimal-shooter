package actor;

import flixel.math.FlxVector;
import flixel.util.FlxPool;

class Vector extends bloc.Vector implements IFlxPooled
{
	private static var _pool = new FlxPool<Vector>(Vector);

	/**
	 * Recycle or create a new vector.
	 * Be sure to put() them back into the pool after you're done with them!
	 *
	 * @return	This vector.
	 */
	public static inline function get():Vector
	{
		var vector = _pool.get();
		vector._inPool = false;

		return vector;
	}

	/**
	 * Recycle or create a new vector which will automatically be released
	 * to the pool when passed into a function (be sure to putWeak() in that function).
	 *
	 * @return	This vector.
	 */
	public static inline function weak():Vector
	{
		var vector = get();
		vector._weak = true;

		return vector;
	}

	private var _weak:Bool = false;
	private var _inPool:Bool = false;

	@:keep
	public function new ()
	{
		super();
	}

	/**
	 * Add this FlxPoint to the recycling pool.
	 */
	public inline function put():Void
	{
		if (_inPool) return;

		_inPool = true;
		_weak = false;
		_pool.putUnsafe(this);
	}

	/**
	 * Add this FlxPoint to the recycling pool if it's a weak reference (allocated via weak()).
	 */
	override public inline function putWeak():Void
	{
		if (_weak)
			put();
	}

	public function destroy():Void
	{
	}

	public inline function toFlxVector():FlxVector
	{
		return FlxVector.get(this.x, this.y);
	}
}

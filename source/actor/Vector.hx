package actor;

import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxPool;

class Vector implements IFlxPooled
{
	private static var _pool = new FlxPool<Vector>(Vector);

	private static var TO_RADIANS = Math.PI / 180.0;

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

	/**
	 * The x value in cartesian coordinates system.
	 */
	public var x(get, set):Float;

	/**
	 * The y value in cartesian coordinates system.
	 */
	public var y(get, set):Float;

	/**
	 * The radius in polar coordinates system (= magnitude of the vector).
	 */
	public var length(get, set):Float;

	/**
	 * The angle (degrees) in polar coordinates system.
	 */
	public var angle(get, set):Float;

	private var _weak:Bool = false;
	private var _inPool:Bool = false;

	private var _cartesianCoords:FlxVector;
	private var _polarCoords:FlxPoint;
	private var _xUpdated:Bool = true;
	private var _yUpdated:Bool = true;
	private var _lengthUpdated:Bool = true;
	private var _angleUpdated:Bool = true;

	@:keep
	public function new ()
	{
		_cartesianCoords = new FlxVector();
		_polarCoords = new FlxPoint();
	}

	/**
	 * Add this FlxPoint to the recycling pool.
	 */
	public function put():Void
	{
		if (_inPool) return;

		_inPool = true;
		_weak = false;
		_pool.putUnsafe(this);
	}

	/**
	 * Add this FlxPoint to the recycling pool if it's a weak reference (allocated via weak()).
	 */
	public inline function putWeak():Void
	{
		if (_weak)
			put();
	}

	public function destroy():Void
	{
	}

	public inline function setCartesian(x:Float, y:Float):Vector
	{
		_xUpdated = true;
		_yUpdated = true;
		_lengthUpdated = false;
		_angleUpdated = false;
		_cartesianCoords.set(x, y);

		return this;
	}

	public inline function setPolar(length:Float, angle:Float):Vector
	{
		_lengthUpdated = true;
		_angleUpdated = true;
		_xUpdated = false;
		_yUpdated = false;
		_polarCoords.set(length, angle);

		return this;
	}

	/**
	 * Adds to the cartesian coordinates of this vector.
	 *
	 * @param	x	Amount to add to x
	 * @param	y	Amount to add to y
	 * @return	This vector.
	 */
	public inline function addCartesian(x:Float, y:Float):Vector
	{
		setCartesian(this.x + x, this.y + y);

		return this;
	}

	/**
	 * Adds the cartesian coordinates of another vector to the cartesian coordinates of this vector.
	 *
	 * @param	vector	The vector to add to this vector
	 * @return	This vector.
	 */

	public inline function add(vector:Vector):Vector
	{
		addCartesian(vector.x, vector.y);
		vector.putWeak();

		return this;
	}

	/**
	 * Subtracts from the cartesian coordinates of this vector.
	 *
	 * @param	x	Amount to subtract from x
	 * @param	y	Amount to subtract from y
	 * @return	This point.
	 */
	public inline function subtractCartesian(x:Float = 0, y:Float = 0):Vector
	{
		setCartesian(this.x - x, this.y - y);

		return this;
	}

	/**
	 * Subtracts the cartesian coordinates of another vector from the cartesian coordinates of this vector.
	 *
	 * @param	vector	The vector to subtract from this vector
	 * @return	This vector.
	 */
	public inline function subtract(vector:Vector):Vector
	{
		subtractCartesian(vector.x, vector.y);
		vector.putWeak();

		return this;
	}

	public inline function toFlxVector():FlxVector
	{
		updateX();
		updateY();

		return _cartesianCoords.clone();
	}

	private inline function updateX():Void
	{
		if (!_xUpdated)
		{
			_cartesianCoords.x = _polarCoords.x * Math.cos(_polarCoords.y * TO_RADIANS);
			_xUpdated = true;
		}
	}

	private inline function updateY():Void
	{
		if (!_yUpdated)
		{
			_cartesianCoords.y = _polarCoords.x * Math.sin(_polarCoords.y * TO_RADIANS);
			_yUpdated = true;
		}
	}

	private inline function updateRadius():Void
	{
		if (!_lengthUpdated)
		{
			_polarCoords.x = _cartesianCoords.length;
			_lengthUpdated = true;
		}
	}

	private inline function updateAngle():Void
	{
		if (!_angleUpdated)
		{
			_polarCoords.y = _cartesianCoords.degrees;
			_angleUpdated = true;
		}
	}

	inline function get_x()
	{
		updateX();

		return _cartesianCoords.x;
	}

	inline function get_y()
	{
		updateY();

		return _cartesianCoords.y;
	}

	inline function set_x(v:Float)
	{
		_xUpdated = true;
		updateY();
		_lengthUpdated = false;
		_angleUpdated = false;

		return _cartesianCoords.x = v;
	}

	inline function set_y(v:Float)
	{
		updateX();
		_yUpdated = true;
		_lengthUpdated = false;
		_angleUpdated = false;

		return _cartesianCoords.y = v;
	}

	inline function get_length()
	{
		updateRadius();

		return _polarCoords.x;
	}

	inline function get_angle()
	{
		updateAngle();

		return _polarCoords.y;
	}

	inline function set_length(v:Float)
	{
		_lengthUpdated = true;
		updateAngle();
		_xUpdated = false;
		_yUpdated = false;

		return _polarCoords.x = v;
	}

	inline function set_angle(v:Float)
	{
		updateRadius();
		_angleUpdated = true;
		_xUpdated = false;
		_yUpdated = false;

		return _polarCoords.y = v;
	}
}

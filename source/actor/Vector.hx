package actor;

import flixel.math.FlxPoint;

class Vector
{
	private static var TO_RADIANS = Math.PI / 180.0;
	private static var TO_DEGREES = 180 / Math.PI;

	/**
	 * The x value in cartesian coordinates system.
	 */
	public var x(get, set): Float;

	/**
	 * The y value in cartesian coordinates system.
	 */
	public var y(get, set): Float;

	/**
	 * The radius in polar coordinates system (= magnitude of the vector).
	 */
	public var radius(get, set): Float;

	/**
	 * The angle (degrees) in polar coordinates system.
	 */
	public var angle(get, set): Float;

	private var _cartesianCoords: FlxPoint;
	private var _polarCoords: FlxPoint;
	private var _xUpdated: Bool = true;
	private var _yUpdated: Bool = true;
	private var _radiusUpdated: Bool = true;
	private var _angleUpdated: Bool = true;

	public function new ()
	{
		_cartesianCoords = new FlxPoint();
		_polarCoords = new FlxPoint();
	}

	public inline function setCartesian(x: Float, y: Float): Vector
	{
		_xUpdated = true;
		_yUpdated = true;
		_radiusUpdated = false;
		_angleUpdated = false;
		_cartesianCoords.x = x;
		_cartesianCoords.y = y;
		return this;
	}

	public inline function setPolar(radius: Float, angle: Float): Vector
	{
		_radiusUpdated = true;
		_angleUpdated = true;
		_xUpdated = false;
		_yUpdated = false;
		_polarCoords.x = radius;
		_polarCoords.y = angle;
		return this;
	}

	private inline function updateX(): Void
	{
		if (!_xUpdated)
		{
			_cartesianCoords.x = _polarCoords.x * Math.cos(_polarCoords.y * TO_RADIANS);
			_xUpdated = true;
		}
	}

	private inline function updateY(): Void
	{
		if (!_yUpdated)
		{
			_cartesianCoords.y = _polarCoords.x * Math.sin(_polarCoords.y * TO_RADIANS);
			_yUpdated = true;
		}
	}

	private inline function updateRadius(): Void
	{
		if (!_radiusUpdated)
		{
			_polarCoords.x = Math.sqrt(
			  _cartesianCoords.x * _cartesianCoords.x + _cartesianCoords.y * _cartesianCoords.y
			);
			_radiusUpdated = true;
		}
	}

	private inline function updateAngle(): Void
	{
		if (!_angleUpdated)
		{
			_polarCoords.y =  Math.atan2(_cartesianCoords.y, _cartesianCoords.x) * TO_DEGREES;
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

	inline function set_x(v: Float)
	{
		_xUpdated = true;
		updateY();
		_radiusUpdated = false;
		_angleUpdated = false;
		return _cartesianCoords.x = v;
	}

	inline function set_y(v: Float)
	{
		updateX();
		_yUpdated = true;
		_radiusUpdated = false;
		_angleUpdated = false;
		return _cartesianCoords.y = v;
	}

	inline function get_radius()
	{
		updateRadius();

		return _polarCoords.x;
	}

	inline function get_angle()
	{
		updateAngle();

		return _polarCoords.y;
	}

	inline function set_radius(v: Float)
	{
		_radiusUpdated = true;
		updateAngle();
		_xUpdated = false;
		_yUpdated = false;
		return _polarCoords.x = v;
	}

	inline function set_angle(v: Float)
	{
		updateRadius();
		_angleUpdated = true;
		_xUpdated = false;
		_yUpdated = false;
		return _polarCoords.y = v;
	}
}

package bloc;

/**
 * Vector class intended to use in both cartesian and polar coordinates.
 */
class Vector
{
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

	private var _cartesianCoords:CartesianCoordsVector;
	private var _polarCoords:PolarCoordsVector;

	private var _xUpdated:Bool = true;
	private var _yUpdated:Bool = true;
	private var _lengthUpdated:Bool = true;
	private var _angleUpdated:Bool = true;

	public function new ()
	{
		this._cartesianCoords = new CartesianCoordsVector();
		this._polarCoords = new PolarCoordsVector();
	}

	/**
	 * Add this vector to the recycling pool if it's a weak reference.
	 * This will automatically called in add() and subtract() methods.
	 * It's empty as this class doesn't pool objects.
	 * Extend this class and override this method when implementing object pooling.
	 */
	public function putWeak():Void
	{
	}

	/**
	 * Copies the values to this vector from the provided vector.
	 *
	 * @param   Vector The vector from which the values will be copied.
	 * @return  This vector.
	 */
	public inline function set(vector:Vector):Vector
	{
		this._cartesianCoords.set(vector._cartesianCoords);
		this._polarCoords.set(vector._polarCoords);
		this._xUpdated = vector._xUpdated;
		this._yUpdated = vector._yUpdated;
		this._lengthUpdated = vector._lengthUpdated;
		this._angleUpdated = vector._angleUpdated;
		vector.putWeak();

		return this;
	}

	/**
	 * Resets the values to zero.
	 *
	 * @return  This vector.
	 */
	public inline function reset():Vector
	{
		this._cartesianCoords.setCoords(0, 0);
		this._polarCoords.setCoords(0, 0);
		this._xUpdated = true;
		this._yUpdated = true;
		this._lengthUpdated = true;
		this._angleUpdated = true;

		return this;
	}

	/**
	 * Sets cartesian coordinates values to this vector.
	 *
	 * @param   x The x value.
	 * @param   y The y value.
	 * @return  This vector.
	 */
	public inline function setCartesian(x:Float, y:Float):Vector
	{
		this._xUpdated = true;
		this._yUpdated = true;
		this._lengthUpdated = false;
		this._angleUpdated = false;
		this._cartesianCoords.setCoords(x, y);

		return this;
	}

	/**
	 * Sets polar coordinates values to this vector.
	 *
	 * @param   length The length value.
	 * @param   angle The angle value.
	 * @return  This vector.
	 */
	public inline function setPolar(length:Float, angle:Float):Vector
	{
		this._lengthUpdated = true;
		this._angleUpdated = true;
		this._xUpdated = false;
		this._yUpdated = false;
		this._polarCoords.setCoords(length, angle);

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
	 * @param	vector The vector to add to this vector.
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
	 * @return	This vector.
	 */
	public inline function subtractCartesian(x:Float = 0, y:Float = 0):Vector
	{
		setCartesian(this.x - x, this.y - y);

		return this;
	}

	/**
	 * Subtracts the cartesian coordinates of another vector from the cartesian coordinates of this vector.
	 *
	 * @param	vector	The vector to subtract from this vector.
	 * @return	This vector.
	 */
	public inline function subtract(vector:Vector):Vector
	{
		subtractCartesian(vector.x, vector.y);
		vector.putWeak();

		return this;
	}

	/**
	 * Constrain the length so that it is not be greater than the provided length.
	 *
	 * @param   maxLength The maximum length.
	 * @return	This vector.
	 */
	public inline function truncate(maxLength:Float):Vector
	{
		if (this.length > maxLength)
			this.length = maxLength;

		return this;
	}

	/**
	 * Converts the cartesian coordinates to string.
	 *
	 * @return  String
	 */
	public function toString():String
	{
		return "[" + this.x + ", " + this.y + "]";
	}

	private inline function updateX():Void
	{
		if (!this._xUpdated)
		{
			this._cartesianCoords.x = this._polarCoords.getX();
			this._xUpdated = true;
		}
	}

	private inline function updateY():Void
	{
		if (!this._yUpdated)
		{
			this._cartesianCoords.y = this._polarCoords.getY();
			this._yUpdated = true;
		}
	}

	private inline function updateLength():Void
	{
		if (!this._lengthUpdated)
		{
			this._polarCoords.length = this._cartesianCoords.getLength();
			this._lengthUpdated = true;
		}
	}

	private inline function updateAngle():Void
	{
		if (!this._angleUpdated)
		{
			this._polarCoords.angle = this._cartesianCoords.getAngle();
			this._angleUpdated = true;
		}
	}

	inline function get_x()
	{
		updateX();

		return this._cartesianCoords.x;
	}

	inline function get_y()
	{
		updateY();

		return this._cartesianCoords.y;
	}

	inline function set_x(v:Float)
	{
		this._xUpdated = true;
		updateY();
		this._lengthUpdated = false;
		this._angleUpdated = false;

		return this._cartesianCoords.x = v;
	}

	inline function set_y(v:Float)
	{
		updateX();
		this._yUpdated = true;
		this._lengthUpdated = false;
		this._angleUpdated = false;

		return this._cartesianCoords.y = v;
	}

	inline function get_length()
	{
		updateLength();

		return this._polarCoords.length;
	}

	inline function get_angle()
	{
		updateAngle();

		return this._polarCoords.angle;
	}

	inline function set_length(v:Float)
	{
		this._lengthUpdated = true;
		updateAngle();
		this._xUpdated = false;
		this._yUpdated = false;

		return this._polarCoords.length = v;
	}

	inline function set_angle(v:Float)
	{
		updateLength();
		this._angleUpdated = true;
		this._xUpdated = false;
		this._yUpdated = false;

		return this._polarCoords.angle = v;
	}
}

private class CartesianCoordsVector
{
	private static var TO_DEGREES = 180 / Math.PI;
	private static var EPSILON = 0.0000001;

	public var x:Float = 0;
	public var y:Float = 0;

	public function new ()
	{
	}

	public inline function set(vector:CartesianCoordsVector)
	{
		this.x = vector.x;
		this.y = vector.y;
	}

	public inline function setCoords(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
	}

	public inline function getLength():Float
	{
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}

	public inline function getAngle():Float
	{
		return if (this.hasZeroLength()) 0 else Math.atan2(this.y, this.x) * TO_DEGREES;
	}

	public inline function hasZeroLength():Bool
	{
		return Math.abs(x) < EPSILON && Math.abs(y) < EPSILON;
	}
}

private class PolarCoordsVector
{
	private static var TO_RADIANS = Math.PI / 180;

	public var length:Float = 0;
	public var angle:Float = 0;

	public function new ()
	{
	}

	public inline function set(vector:PolarCoordsVector)
	{
		this.length = vector.length;
		this.angle = vector.angle;
	}

	public inline function setCoords(length:Float, angle:Float)
	{
		this.length = length;
		this.angle = angle;
	}

	public inline function getX():Float
	{
		return this.length * Math.cos(this.angle * TO_RADIANS);
	}

	public inline function getY():Float
	{
		return this.length * Math.sin(this.angle * TO_RADIANS);
	}
}

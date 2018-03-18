package bloc;

using bloc.Utility;
import bloc.Utility.EPSILON;

/**
 * Vector class intended to use in both cartesian and polar coordinates.
 */
class Vector
{
	private static var _dummyReference:Vector = new Vector();
	private static var _temporalVector:Vector = new Vector();

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
	public var angle(get, set):DirectionAngle;

	/**
	 * The reference to the x value.
	 */
	public var xRef(default, null):VectorXReference;

	/**
	 * The reference to the y value.
	 */
	public var yRef(default, null):VectorYReference;

	/**
	 * The reference to the length value.
	 */
	public var lengthRef(default, null):VectorLengthReference;

	/**
	 * The reference to the angle value.
	 */
	public var angleRef(default, null):VectorAngleReference;

	private var _cartesianCoords:CartesianCoordsVector;
	private var _polarCoords:PolarCoordsVector;

	private var _xUpdated:Bool;
	private var _yUpdated:Bool;
	private var _lengthUpdated:Bool;
	private var _angleUpdated:Bool;

	private var _referer:Referer;
	private var _reference:Vector;

	public function new ()
	{
		this._cartesianCoords = new CartesianCoordsVector();
		this._polarCoords = new PolarCoordsVector();
		this.xRef = new VectorXReference(this);
		this.yRef = new VectorYReference(this);
		this.lengthRef = new VectorLengthReference(this);
		this.angleRef = new VectorAngleReference(this);
		this.reset();
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
	 * Resets the vector so that it will be an absolute zero vector.
	 *
	 * @return  This vector.
	 */
	public inline function reset():Vector
	{
		this._cartesianCoords.setCoords(0, 0);
		this._polarCoords.setCoords(0, DirectionAngle.fromZero());
		this._xUpdated = true;
		this._yUpdated = true;
		this._lengthUpdated = true;
		this._angleUpdated = true;
		this.setAbsoluteReference();

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
	public inline function setPolar(length:Float, angle:DirectionAngle):Vector
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
		this.setCartesian(this.x + x, this.y + y);

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
		this.addCartesian(vector.x, vector.y);
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
		this.setCartesian(this.x - x, this.y - y);

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
		this.subtractCartesian(vector.x, vector.y);
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
	 * Sets the vector as an absolute vector. At default the vector is absolute.
	 *
	 * @return  This vector.
	 */
	public inline function setAbsoluteReference():Vector
	{
		this._referer = Referers.absolute;
		this._reference = Vector._dummyReference;

		return this;
	}

	/**
	 * Sets the vector's reference. This enables the vector to be considered as a relative vector.
	 *
	 * @param   reference The reference vector.
	 * @return  This vector.
	 */
	public inline function setRelativeReference(reference:Vector):Vector
	{
		this._referer = Referers.relative;
		this._reference = reference;

		return this;
	}

	/**
	 * Sets the coordinates according to the current absolute coordinates and sets the vector as absolute.
	 * Useful for changing the vector from relative to absolute without changing the absolute coordinates.
	 *
	 * @return  Vector
	 */
	public inline function absolutize():Vector
	{
		this.calculateAbsolute(Vector._temporalVector);
		this.setAbsoluteReference();
		this.set(Vector._temporalVector);

		return this;
	}

	/**
	 * Calculates the absolute coordinates and copies that values to the target vector.
	 *
	 * @param   target The vector for receiving the result.
	 */
	public inline function calculateAbsolute(target:Vector):Void
	{
		this._referer.refer(this, this._reference, target);
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
		this.updateX();

		return this._cartesianCoords.x;
	}

	inline function get_y()
	{
		this.updateY();

		return this._cartesianCoords.y;
	}

	inline function set_x(v:Float)
	{
		this._xUpdated = true;
		this.updateY();
		this._lengthUpdated = false;
		this._angleUpdated = false;

		return this._cartesianCoords.x = v;
	}

	inline function set_y(v:Float)
	{
		this.updateX();
		this._yUpdated = true;
		this._lengthUpdated = false;
		this._angleUpdated = false;

		return this._cartesianCoords.y = v;
	}

	inline function get_length()
	{
		this.updateLength();

		return this._polarCoords.length;
	}

	inline function get_angle()
	{
		this.updateAngle();

		return this._polarCoords.angle;
	}

	inline function set_length(v:Float)
	{
		this._lengthUpdated = true;
		this.updateAngle();
		this._xUpdated = false;
		this._yUpdated = false;

		return this._polarCoords.length = v;
	}

	inline function set_angle(v:DirectionAngle)
	{
		this.updateLength();
		this._angleUpdated = true;
		this._xUpdated = false;
		this._yUpdated = false;

		return this._polarCoords.angle = v;
	}
}



private class CartesianCoordsVector
{
	public var x:Float = 0;
	public var y:Float = 0;

	public function new ()
	{}

	public inline function set(vector:CartesianCoordsVector):Void
	{
		this.x = vector.x;
		this.y = vector.y;
	}

	public inline function setCoords(x:Float, y:Float):Void
	{
		this.x = x;
		this.y = y;
	}

	public inline function getLength():Float
	{
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}

	public inline function getAngle():DirectionAngle
	{
		return if (this.hasZeroLength()) DirectionAngle.fromZero() else DirectionAngle.fromRadians(Math.atan2(this.y, this.x));
	}

	public inline function hasZeroLength():Bool
	{
		return Math.abs(x) < EPSILON && Math.abs(y) < EPSILON;
	}
}

private class PolarCoordsVector
{
	public var length:Float = 0;
	public var angle:DirectionAngle = DirectionAngle.fromZero();

	public function new ()
	{}

	public inline function set(vector:PolarCoordsVector):Void
	{
		this.length = vector.length;
		this.angle = vector.angle;
	}

	public inline function setCoords(length:Float, angle:DirectionAngle):Void
	{
		this.length = length;
		this.angle = angle;
	}

	public inline function getX():Float
	{
		return this.length * Math.cos(this.angle.toRadians());
	}

	public inline function getY():Float
	{
		return this.length * Math.sin(this.angle.toRadians());
	}
}



private class Referers
{
	public static var absolute = new AbsoluteReferer();
	public static var relative = new RelativeReferer();
}

private class Referer
{
	public function new ()
	{}

	public function refer(vector:Vector, reference:Vector, target:Vector):Void
	{
	}
}

private class AbsoluteReferer extends Referer
{
	override public inline function refer(vector:Vector, reference:Vector, target:Vector):Void
	{
		target.set(vector);
	}
}

private class RelativeReferer extends Referer
{
	override public inline function refer(vector:Vector, reference:Vector, target:Vector):Void
	{
		reference.calculateAbsolute(target);
		target.add(vector);
	}
}



private class VectorValueReference
{
	private var _vector:Vector;

	public function new (vector:Vector)
	{ this._vector = vector; }
}

private class VectorXReference extends VectorValueReference implements FloatRef
{
	public var value(get, set):Float;

	public inline function get_value()
	{ return this._vector.x; }

	public inline function set_value(value:Float)
	{ return this._vector.x = value; }
}

private class VectorYReference extends VectorValueReference implements FloatRef
{
	public var value(get, set):Float;

	public inline function get_value()
	{ return this._vector.y; }

	public inline function set_value(value:Float)
	{ return this._vector.y = value; }
}

private class VectorLengthReference extends VectorValueReference implements FloatRef
{
	public var value(get, set):Float;

	public inline function get_value()
	{ return this._vector.length; }

	public inline function set_value(value:Float)
	{ return this._vector.length = value; }
}

private class VectorAngleReference extends VectorValueReference implements DirectionAngleRef
{
	public var value(get, set):DirectionAngle;

	public inline function get_value()
	{ return this._vector.angle; }

	public inline function set_value(value:DirectionAngle)
	{ return this._vector.angle = value; }
}

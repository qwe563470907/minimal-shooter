package bloc;

abstract DirectionAngle(Float)
{
	private inline function new (radians:Float)
	{ this = radians; }

	/**
	 * Creates an direction angle value from BLOC degrees (0 for the direction of 12 o'clock, clockwise).
	 *
	 * @param   blocDegrees The value in BLOC degrees.
	 * @return  DirectionAngle
	 */
	public static inline function fromBlocDegrees(blocDegrees:Float):DirectionAngle
		return fromDegrees(blocDegrees - 90.0);

	/**
	 * Creates an direction angle value from degrees (0 for the direction of 3 o'clock, clockwise).
	 *
	 * @param   degrees The value in degrees.
	 * @return  DirectionAngle
	 */
	public static inline function fromDegrees(degrees:Float):DirectionAngle
		return fromRadians(degrees * Utility.TO_RADIANS);

	/**
	 * Creates an direction angle value from radians (0 for the direction of 3 o'clock, clockwise).
	 *
	 * @param   radians The value in radians.
	 * @return  DirectionAngle
	 */
	public static inline function fromRadians(radians:Float):DirectionAngle
		return new DirectionAngle(radians);

	/**
	 * Creates an direction zero angle value.
	 *
	 * @return  DirectionAngle
	 */
	public static inline function fromZero():DirectionAngle
		return fromRadians(0);

	/**
	 * Converts the direction angle to Float in radians (0 for the direction of 3 o'clock, clockwise).
	 *
	 * @return  Float
	 */
	public inline function toRadians():Float
		return this;

	/**
	 * Converts the direction angle to Float in degrees (0 for the direction of 3 o'clock, clockwise).
	 *
	 * @return  Float
	 */
	public inline function toDegrees():Float
		return toRadians() * Utility.TO_DEGREES;

	/**
	 * Converts the direction angle to Float in BLOC degrees (0 for the direction of 12 o'clock, clockwise).
	 *
	 * @return  Float
	 */
	public inline function toBlocDegrees():Float
		return toDegrees() + 90.0;

	/**
	 * Converts the direction angle to String in BLOC degrees (0 for the direction of 12 o'clock, clockwise).
	 *
	 * @return  String
	 */
	@:to public inline function toString():String
		return "" + 0.01 * Math.round(100.0 * toBlocDegrees());

	/**
	 * Returns true if the value is zero or very nearly zero.
	 *
	 * @return  Bool
	 */
	public inline function isZero():Bool
		return Math.abs(this) < Utility.EPSILON;

	@:op(A - B) static public function subtract(a:DirectionAngle, b:DirectionAngle):AngleInterval;
}

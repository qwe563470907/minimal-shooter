package bloc;

abstract AngleInterval(Float)
{
	private static var TO_RADIANS = Math.PI / 180.0;
	private static var TO_DEGREES = 180.0 / Math.PI;

	private inline function new (radians:Float)
	{ this = radians; }

	/**
	 * Creates an angle interval value from degrees.
	 *
	 * @param   degrees The value in degrees.
	 * @return  AngleInterval
	 */
	public static inline function fromDegrees(degrees:Float):AngleInterval
		return fromRadians(degrees * TO_RADIANS);

	/**
	 * Creates an angle interval value from radians.
	 *
	 * @param   radians The value in radians.
	 * @return  AngleInterval
	 */
	public static inline function fromRadians(radians:Float):AngleInterval
		return new AngleInterval(radians);

	/**
	 * Creates a zero angle interval value.
	 *
	 * @return  AngleInterval
	 */
	public static inline function fromZero():AngleInterval
		return fromRadians(0);

	/**
	 * Converts the angle interval to Float in radians.
	 *
	 * @return  Float
	 */
	public inline function toRadians():Float
		return this;

	/**
	 * Converts the angle interval to Float in degrees.
	 *
	 * @return  Float
	 */
	public inline function toDegrees():Float
		return toRadians() * TO_DEGREES;

	/**
	 * Converts the angle interval to String in degrees.
	 *
	 * @return  String
	 */
	@:to public inline function toString():String
		return "" + 0.01 * Math.round(100.0 * toDegrees());

	@:op(A + B) static public function directionPlusInterval(a:DirectionAngle, b:AngleInterval):DirectionAngle;
	@:op(A + B) static public function intervalPlusDirection(a:AngleInterval, b:DirectionAngle):DirectionAngle;
	@:op(A + B) static public function intervalPlusInterval(a:AngleInterval, b:AngleInterval):AngleInterval;
	@:op(A - B) static public function directionMinusInterval(a:DirectionAngle, b:AngleInterval):DirectionAngle;
	@:op(A - B) static public function intervalMinusInterval(a:AngleInterval, b:AngleInterval):AngleInterval;
	@:op(A * B) static public function floatTimesInterval(a:Float, b:AngleInterval):AngleInterval;
	@:op(A * B) static public function intervalFloatTimes(a:AngleInterval, b:Float):AngleInterval;
	@:op(A / B) static public function intervalDivideByFloat(a:AngleInterval, b:Float):AngleInterval;
}

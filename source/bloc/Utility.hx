package bloc;

import bloc.element.NullElement;

class Utility
{
	public static var NULL_ELEMENT = new NullElement();
	public static var NULL_PATTERN = new Pattern.NullPattern();

	public static inline var EPSILON = 0.0000001;
	public static var TO_RADIANS = Math.PI / 180.0;
	public static var TO_DEGREES = 180.0 / Math.PI;
	public static var TWO_PI = 2 * Math.PI;

	public static var NULL_FLOAT_REF = new NullFloatRef();
	public static var NULL_DIRECTION_ANGLE_REF = new NullDirectionAngleRef();

	/**
	 * Calculates the difference between two angles in range of -PI to PI.
	 * @param angleA - the angle to subtract from
	 * @param angleB - the angle to subtract
	 */
	public static inline function angleDifference(angleA: DirectionAngle, angleB: DirectionAngle): AngleInterval
	{
		var diffRadians = (angleA - angleB).toRadians() % TWO_PI;

		if (diffRadians < -Math.PI) diffRadians += TWO_PI;
		else if (diffRadians > Math.PI) diffRadians -= TWO_PI;

		return AngleInterval.fromRadians(diffRadians);
	}
}

interface FloatRef
{
	public var value(get, set):Float;
}

class NullFloatRef implements FloatRef
{
	public var value(get, set):Float;

	public function new ()
	{}

	inline function get_value()
	{
		return 0;
	}

	inline function set_value(value:Float)
	{
		return 0;
	}
}

interface DirectionAngleRef
{
	public var value(get, set):DirectionAngle;
}

class NullDirectionAngleRef implements DirectionAngleRef
{
	public var value(get, set):DirectionAngle;

	public function new ()
	{}

	inline function get_value()
	{
		return DirectionAngle.fromZero();
	}

	inline function set_value(value:DirectionAngle)
	{
		return DirectionAngle.fromZero();
	}
}
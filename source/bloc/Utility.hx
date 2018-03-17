package bloc;

import bloc.element.NullElement;

class Utility
{
	public static var NULL_ELEMENT = new NullElement();
	public static var NULL_PATTERN = new Pattern.NullPattern();

	public static inline var EPSILON = 0.0000001;
	public static var TO_RADIANS = Math.PI / 180.0;
	public static var TO_DEGREES = 180.0 / Math.PI;
}

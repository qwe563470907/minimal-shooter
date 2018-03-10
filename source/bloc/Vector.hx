package bloc;

interface Vector
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
}

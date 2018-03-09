package bloc.element;

class Velocity extends PositionalElement
{
	private var _speed:Float;
	private var _directionAngle:Float;

	private function new (speed:Float, directionAngle:Float)
	{
		var radians = 2 * Math.PI * directionAngle / 360.0;
		super(speed * Math.cos(radians), speed * Math.sin(radians));
		this._speed = speed;
		this._directionAngle = directionAngle;
	}
}

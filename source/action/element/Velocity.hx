package action.element;

class Velocity extends PositionalElement
{
	private function new(directionAngle:Float, speed:Float)
	{
		var radians = 2 * Math.PI * directionAngle / 360.0;
		super(speed * Math.cos(radians), speed * Math.sin(radians));
	}
}

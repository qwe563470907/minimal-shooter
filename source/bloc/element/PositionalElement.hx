package bloc.element;

class PositionalElement extends DefaultElement
{
	private var _x:Float;
	private var _y:Float;

	private function new (x:Float, y:Float)
	{
		super();
		this._x = x;
		this._y = y;
	}
}

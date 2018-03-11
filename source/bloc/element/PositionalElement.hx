package bloc.element;

class PositionalElement extends DefaultElement
{
	private var _vector:Vector;

	private function new (vector:Vector)
	{
		super();
		this._vector = vector;
	}
}

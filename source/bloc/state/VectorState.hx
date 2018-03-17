package bloc.state;

class VectorState implements State
{
	public var value:Null<Vector>;

	public function new ()
	{
		reset();
	}

	public inline function reset():Void
	{
		this.value = null;
	}
}

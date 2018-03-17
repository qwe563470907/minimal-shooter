package bloc.state;

class FloatState implements State
{
	public var value:Null<Float>;

	public function new ()
	{
		reset();
	}

	public inline function reset():Void
	{
		this.value = null;
	}
}

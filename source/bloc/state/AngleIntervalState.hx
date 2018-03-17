package bloc.state;

class AngleIntervalState implements State
{
	public var value:Null<AngleInterval>;

	public function new ()
	{
		reset();
	}

	public inline function reset():Void
	{
		this.value = null;
	}
}

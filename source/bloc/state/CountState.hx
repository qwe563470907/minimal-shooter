package bloc.state;

class CountState implements State
{
	public var count(get, null):Int;
	public var isCompleted(get, null):Bool;
	private var maxCount:Int;

	public function new (maxCount:Int)
	{
		this.count = 0;
		this.maxCount = maxCount;
		this.isCompleted = false;
	}

	public function increment():Void
	{
		this.count++;

		if (this.count >= this.maxCount) this.isCompleted = true;
	}

	public function reset():Void
	{
		this.count = 0;
		this.isCompleted = false;
	}

	public function get_count():Int
	{
		return this.count;
	}

	public function get_isCompleted():Bool
	{
		return this.isCompleted;
	}
}
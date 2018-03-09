package bloc.element;

class Fire extends DefaultElement
{
	private var _speed:Null<Float>;
	private var _direction:Null<Float>;

	public function new (?speed:Float, ?direction:Float)
	{
		super();
		this._speed = speed;
		this._direction = direction;
	}

	override public function run(actor:Actor):Bool
	{
		actor.fire(this._speed, this._direction);

		return true;
	}

	override public function toString():String
	{
		return "fire -spd " + this._speed + " -dir " + this._direction;
	}
}

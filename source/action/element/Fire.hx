package action.element;

class Fire extends DefaultElement {
	private var _directionAngle:Null<Float>;
	private var _speed:Null<Float>;
	private var _offsetX:Null<Float>;
	private var _offsetY:Null<Float>;

	public function new(?directionAngle:Float, ?speed:Float, ?offsetX:Float, ?offsetY:Float)
	{
		super();
		this._directionAngle = directionAngle;
		this._speed = speed;
		this._offsetX = offsetX;
		this._offsetY = offsetY;
	}

	override public function run(actor: IActor):Bool
	{
		actor.fire(this._directionAngle, this._speed, this._offsetX, this._offsetY);
		return true;
	}
}

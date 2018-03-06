package action.element;

class SetPosition extends PositionalElement
{
	public function new(x:Float, y:Float)
	{
    super(x, y);
  }

	override public function run(actor: IActor):Bool
	{
		actor.setPosition(_x, _y);
		return true;
	}
}

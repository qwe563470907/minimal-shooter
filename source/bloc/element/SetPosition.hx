package bloc.element;

class SetPosition extends PositionalElement
{
	public function new (vector:Vector)
	{
		super(vector);
	}

	override public function run(actor:Actor):Bool
	{
		actor.position.set(this._vector);

		return true;
	}
}

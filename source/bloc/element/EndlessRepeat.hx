package bloc.element;

class EndlessRepeat extends Sequence
{
	public function new (action: Element, ? intervalWaitCount : Int)
	{
		super([action, new Wait(intervalWaitCount)]);
	}

	override public function run(actor: Actor): Bool
	{
		if (super.run(actor))
			this.resetState(actor);

		return false;
	}

	override public function toString(): String
	{
		return "endless " + super.toString();
	}
}

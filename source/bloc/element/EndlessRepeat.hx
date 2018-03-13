package bloc.element;

class EndlessRepeat extends Sequence
{
	public function new (pattern:Pattern, ?intervalWaitCount:Int)
	{
		super([pattern, new Wait(intervalWaitCount)]);
	}

	override public inline function run(actor:Actor):Bool
	{
		if (super.run(actor))
			this.resetState(actor);

		return false;
	}

	override public function toString():String
	{
		return "endless " + super.toString();
	}
}

package action.element;

class EndlessRepeat extends Sequence {
	public function new(action: IElement, ?intervalWaitCount: Int) {
		super([action, new Wait(intervalWaitCount)]);
	}

	override public function run(actor: IActor): Bool {
		if (super.run(actor))
		{
			this.resetState(actor);
		}

		return false;
	}
}

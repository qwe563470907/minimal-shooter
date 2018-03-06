package action.element;

class Sequence extends List {
	public function new(actionList: Array<IElement>) {
		super(actionList);
	}

	override public function run(actor: IActor): Bool {
		var state = actor.actionStateManager.getCountState(this);

		while(!state.isCompleted) {
			var completed = this.actionList[state.count].run(actor);

			if(!completed) return false;

			state.increment();
		}

		this.resetChildrenState(actor);

		return true;
	}

	override public function prepareState(manager: StateManager): Void {
		super.prepareState(manager);

		var actionListLength = this.actionList.length;
		manager.countStateMap.set(this, new CountState(actionListLength));
	}

	override public function resetState(actor: IActor): Void {
		actor.actionStateManager.getCountState(this).reset();
	}
}

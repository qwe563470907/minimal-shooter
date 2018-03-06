package action.element;

class Repeat extends DefaultElement {
	public var action: Element;
	private var repetitionCount: Int;

	public function new(action: Element, count: Int) {
		super();
		this.action = action;
		this.repetitionCount = count;
	}

	override public function run(actor: IActor): Bool {
		var state = actor.actionStateManager.getCountState(this);

		while(!state.isCompleted) {
			var completed = this.action.run(actor);

			if(!completed) return false;

			this.action.resetState(actor);
			state.increment();
		}

		return true;
	}

	override public function prepareState(manager: StateManager): Void {
		manager.countStateMap.set(this, new CountState(this.repetitionCount));
		this.action.prepareState(manager);
	}

	override public function resetState(actor: IActor): Void {
		actor.actionStateManager.getCountState(this).reset();
	}
}

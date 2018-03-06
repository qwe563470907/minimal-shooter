package action.element;

class List extends DefaultElement {
	public var actionList: Array<Element>;

	private function new(actionList: Array<Element>) {
		super();
		this.actionList = actionList.copy();
	}

	public function resetChildrenState(actor: IActor): Void {
		for(i in 0...this.actionList.length)
			this.actionList[i].resetState(actor);
	}

	override public function prepareState(manager: StateManager): Void {
		for(i in 0...this.actionList.length)
			this.actionList[i].prepareState(manager);
	}
}

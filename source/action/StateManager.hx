package action;

import action.element.IElement;

class StateManager {
	static private var NULL_COUNT_STATE = new CountState(0);

	public var countStateMap: Map<IElement, CountState>;

	public function new() {
		this.countStateMap = new Map<IElement, CountState>();
	}

	public function clear():Void {
		for(key in countStateMap.keys())
			countStateMap.remove(key);
	}

	public function getCountState(action: IElement): CountState {
		var state = this.countStateMap.get(action);
		return if (state != null) state else NULL_COUNT_STATE;
	}
}

package action;

import action.element.Element;

class StateManager {
	static private var NULL_COUNT_STATE = new CountState(0);

	public var countStateMap: Map<Element, CountState>;

	public function new() {
		this.countStateMap = new Map<Element, CountState>();
	}

	public function clear():Void {
		for(key in countStateMap.keys())
			countStateMap.remove(key);
	}

	public function getCountState(action: Element): CountState {
		var state = this.countStateMap.get(action);
		return if (state != null) state else NULL_COUNT_STATE;
	}
}

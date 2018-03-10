package bloc;

import bloc.element.Element;

class StateManager
{
	static private var NULL_COUNT_STATE = new CountState(0);
	static private var NULL_BRANCH_STATE = new ConditionalBranchState();

	public var countStateMap:Map<Element, CountState>;
	public var branchStateMap:Map<Element, ConditionalBranchState>;

	public function new ()
	{
		this.countStateMap = new Map<Element, CountState>();
		this.branchStateMap = new Map<Element, ConditionalBranchState>();
	}

	public function clear():Void
	{
		for (key in countStateMap.keys())
			countStateMap.remove(key);

		for (key in branchStateMap.keys())
			branchStateMap.remove(key);
	}

	public function getCountState(element:Element):CountState
	{
		var state = this.countStateMap.get(element);

		return if (state != null) state else NULL_COUNT_STATE;
	}

	public function getBranchState(element:Element):ConditionalBranchState
	{
		var state = this.branchStateMap.get(element);

		return if (state != null) state else NULL_BRANCH_STATE;
	}
}

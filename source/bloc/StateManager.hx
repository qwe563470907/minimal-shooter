package bloc;

import bloc.element.Element;
import bloc.state.*;

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

	public inline function clear():Void
	{
		for (key in countStateMap.keys())
			countStateMap.remove(key);

		for (key in branchStateMap.keys())
			branchStateMap.remove(key);
	}

	public inline function getCountState(element:Element):CountState
	{
		var state = this.countStateMap.get(element);

		return if (state != null) state else NULL_COUNT_STATE;
	}

	public inline function getBranchState(element:Element):ConditionalBranchState
	{
		var state = this.branchStateMap.get(element);

		return if (state != null) state else NULL_BRANCH_STATE;
	}

	public inline function addCountState(element:Element, maxCount:Int)
	{
		this.countStateMap.set(element, new CountState(maxCount));
	}
}

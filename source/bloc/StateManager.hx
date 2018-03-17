package bloc;

import bloc.element.Element;
import bloc.state.*;

// Todo: refactor

class StateManager
{
	static private var NULL_COUNT_STATE = new CountState(0);
	static private var NULL_BRANCH_STATE = new ConditionalBranchState();
	static private var NULL_FLOAT_STATE = new FloatState();
	static private var NULL_ANGLE_INTERVAL_STATE = new AngleIntervalState();
	static private var NULL_VECTOR_STATE = new VectorState();

	public var countStateMap:Map<Element, CountState>;
	public var branchStateMap:Map<Element, ConditionalBranchState>;
	public var floatStateMap:Map<Element, FloatState>;
	public var angleIntervalStateMap:Map<Element, AngleIntervalState>;
	public var vectorStateMap:Map<Element, VectorState>;

	public function new ()
	{
		this.countStateMap = new Map<Element, CountState>();
		this.branchStateMap = new Map<Element, ConditionalBranchState>();
		this.floatStateMap = new Map<Element, FloatState>();
		this.angleIntervalStateMap = new Map<Element, AngleIntervalState>();
		this.vectorStateMap = new Map<Element, VectorState>();
	}

	public inline function clear():Void
	{
		for (key in countStateMap.keys())
			countStateMap.remove(key);

		for (key in branchStateMap.keys())
			branchStateMap.remove(key);

		for (key in floatStateMap.keys())
			floatStateMap.remove(key);

		for (key in angleIntervalStateMap.keys())
			angleIntervalStateMap.remove(key);

		for (key in vectorStateMap.keys())
			vectorStateMap.remove(key);
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

	public inline function getFloatState(element:Element):FloatState
	{
		var state = this.floatStateMap.get(element);

		return if (state != null) state else NULL_FLOAT_STATE;
	}

	public inline function getAngleIntervalState(element:Element):AngleIntervalState
	{
		var state = this.angleIntervalStateMap.get(element);

		return if (state != null) state else NULL_ANGLE_INTERVAL_STATE;
	}

	public inline function getVectorState(element:Element):VectorState
	{
		var state = this.vectorStateMap.get(element);

		return if (state != null) state else NULL_VECTOR_STATE;
	}

	public inline function addCountState(element:Element, maxCount:Int)
	{
		this.countStateMap.set(element, new CountState(maxCount));
	}

	public inline function addFloatState(element:Element)
	{
		this.floatStateMap.set(element, new FloatState());
	}

	public inline function addAngleIntervalState(element:Element)
	{
		this.angleIntervalStateMap.set(element, new AngleIntervalState());
	}

	public inline function addVectorState(element:Element)
	{
		this.vectorStateMap.set(element, new VectorState());
	}
}

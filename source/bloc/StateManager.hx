package bloc;

import de.polygonal.ds.HashTable;
import bloc.element.Element;
import bloc.state.*;

class StateManager
{
	static private var NULL_COUNT_STATE(default, never) = new CountState();
	static private var NULL_BRANCH_STATE(default, never) = new ConditionalBranchState();
	static private var NULL_FLOAT_STATE(default, never) = new FloatState();
	static private var NULL_ANGLE_INTERVAL_STATE(default, never) = new AngleIntervalState();
	static private var NULL_VECTOR_STATE(default, never) = new VectorState();
	static private var NULL_PARALLEL_STATE(default, never) = new ParallelState();

	public var countStateMap:HashTable<Element, CountState>;
	public var branchStateMap:HashTable<Element, ConditionalBranchState>;
	public var floatStateMap:HashTable<Element, FloatState>;
	public var angleIntervalStateMap:HashTable<Element, AngleIntervalState>;
	public var vectorStateMap:HashTable<Element, VectorState>;
	public var parallelStateMap:HashTable<Element, ParallelState>;

	public function new ()
	{
		this.countStateMap = new HashTable<Element, CountState>(32, 32);
		this.countStateMap.reuseIterator = true;
		this.branchStateMap = new HashTable<Element, ConditionalBranchState>(4, 4);
		this.branchStateMap.reuseIterator = true;
		this.floatStateMap = new HashTable<Element, FloatState>(16, 16);
		this.floatStateMap.reuseIterator = true;
		this.angleIntervalStateMap = new HashTable<Element, AngleIntervalState>(8, 8);
		this.angleIntervalStateMap.reuseIterator = true;
		this.vectorStateMap = new HashTable<Element, VectorState>(16, 16);
		this.vectorStateMap.reuseIterator = true;
		this.parallelStateMap = new HashTable<Element, ParallelState>(8, 8);
		this.parallelStateMap.reuseIterator = true;
	}

	public inline function clear():Void
	{
		for (state in this.countStateMap)
			CountState.put(state);

		for (state in this.branchStateMap)
			ConditionalBranchState.put(state);

		for (state in this.floatStateMap)
			FloatState.put(state);

		for (state in this.angleIntervalStateMap)
			AngleIntervalState.put(state);

		for (state in this.vectorStateMap)
			VectorState.put(state);

		for (state in this.parallelStateMap)
			ParallelState.put(state);

		this.countStateMap.clear();
		this.branchStateMap.clear();
		this.floatStateMap.clear();
		this.angleIntervalStateMap.clear();
		this.vectorStateMap.clear();
		this.parallelStateMap.clear();
	}

	public inline function getCountState(element:Element):CountState
	{
		var state = this.countStateMap.get(element);

		return if (checkNull(state)) state else NULL_COUNT_STATE;
	}

	public inline function getBranchState(element:Element):ConditionalBranchState
	{
		var state = this.branchStateMap.get(element);

		return if (checkNull(state)) state else NULL_BRANCH_STATE;
	}

	public inline function getFloatState(element:Element):FloatState
	{
		var state = this.floatStateMap.get(element);

		return if (checkNull(state)) state else NULL_FLOAT_STATE;
	}

	public inline function getAngleIntervalState(element:Element):AngleIntervalState
	{
		var state = this.angleIntervalStateMap.get(element);

		return if (checkNull(state)) state else NULL_ANGLE_INTERVAL_STATE;
	}

	public inline function getVectorState(element:Element):VectorState
	{
		var state = this.vectorStateMap.get(element);

		return if (checkNull(state)) state else NULL_VECTOR_STATE;
	}

	public inline function getParallelState(element:Element):ParallelState
	{
		var state = this.parallelStateMap.get(element);

		return if (checkNull(state)) state else NULL_PARALLEL_STATE;
	}

	public inline function addCountState(element:Element, maxCount:Int)
	{
		var state = CountState.get();
		state.maxCount = maxCount;
		this.countStateMap.set(element, state);
	}

	public inline function addFloatState(element:Element)
	{
		this.floatStateMap.set(element, FloatState.get());
	}

	public inline function addAngleIntervalState(element:Element)
	{
		this.angleIntervalStateMap.set(element, AngleIntervalState.get());
	}

	public inline function addVectorState(element:Element)
	{
		this.vectorStateMap.set(element, VectorState.get());
	}

	public inline function addParallelState(element:Element)
	{
		this.parallelStateMap.set(element, ParallelState.get());
	}

	private inline function checkNull(state:Null<State>):Bool
	{

		return if (state == null)
		{
			trace("[BLOC] Warning: Failed to get state.");
			false;
		}
		else true;
	}
}

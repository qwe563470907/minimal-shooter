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

	private var _countStateMap:HashTable<Element, CountState>;
	private var _branchStateMap:HashTable<Element, ConditionalBranchState>;
	private var _floatStateMap:HashTable<Element, FloatState>;
	private var _angleIntervalStateMap:HashTable<Element, AngleIntervalState>;
	private var _vectorStateMap:HashTable<Element, VectorState>;
	private var _parallelStateMap:HashTable<Element, ParallelState>;

	public function new ()
	{
		this._countStateMap = new HashTable<Element, CountState>(32, 32);
		this._countStateMap.reuseIterator = true;
		this._branchStateMap = new HashTable<Element, ConditionalBranchState>(4, 4);
		this._branchStateMap.reuseIterator = true;
		this._floatStateMap = new HashTable<Element, FloatState>(16, 16);
		this._floatStateMap.reuseIterator = true;
		this._angleIntervalStateMap = new HashTable<Element, AngleIntervalState>(8, 8);
		this._angleIntervalStateMap.reuseIterator = true;
		this._vectorStateMap = new HashTable<Element, VectorState>(16, 16);
		this._vectorStateMap.reuseIterator = true;
		this._parallelStateMap = new HashTable<Element, ParallelState>(8, 8);
		this._parallelStateMap.reuseIterator = true;
	}

	public inline function clear():Void
	{
		for (state in this._countStateMap)
			CountState.put(state);

		for (state in this._branchStateMap)
			ConditionalBranchState.put(state);

		for (state in this._floatStateMap)
			FloatState.put(state);

		for (state in this._angleIntervalStateMap)
			AngleIntervalState.put(state);

		for (state in this._vectorStateMap)
			VectorState.put(state);

		for (state in this._parallelStateMap)
			ParallelState.put(state);

		this._countStateMap.clear();
		this._branchStateMap.clear();
		this._floatStateMap.clear();
		this._angleIntervalStateMap.clear();
		this._vectorStateMap.clear();
		this._parallelStateMap.clear();
	}

	public inline function getCountState(element:Element):CountState
	{
		var state = this._countStateMap.get(element);

		return if (checkNull(state)) state else NULL_COUNT_STATE;
	}

	public inline function getBranchState(element:Element):ConditionalBranchState
	{
		var state = this._branchStateMap.get(element);

		return if (checkNull(state)) state else NULL_BRANCH_STATE;
	}

	public inline function getFloatState(element:Element):FloatState
	{
		var state = this._floatStateMap.get(element);

		return if (checkNull(state)) state else NULL_FLOAT_STATE;
	}

	public inline function getAngleIntervalState(element:Element):AngleIntervalState
	{
		var state = this._angleIntervalStateMap.get(element);

		return if (checkNull(state)) state else NULL_ANGLE_INTERVAL_STATE;
	}

	public inline function getVectorState(element:Element):VectorState
	{
		var state = this._vectorStateMap.get(element);

		return if (checkNull(state)) state else NULL_VECTOR_STATE;
	}

	public inline function getParallelState(element:Element):ParallelState
	{
		var state = this._parallelStateMap.get(element);

		return if (checkNull(state)) state else NULL_PARALLEL_STATE;
	}

	public inline function addCountState(element:Element, maxCount:Int)
	{
		var state = CountState.get();
		state.maxCount = maxCount;
		this._countStateMap.set(element, state);
	}

	public inline function addBranchState(element:Element)
	{
		this._branchStateMap.set(element, ConditionalBranchState.get());
	}

	public inline function addFloatState(element:Element)
	{
		this._floatStateMap.set(element, FloatState.get());
	}

	public inline function addAngleIntervalState(element:Element)
	{
		this._angleIntervalStateMap.set(element, AngleIntervalState.get());
	}

	public inline function addVectorState(element:Element)
	{
		this._vectorStateMap.set(element, VectorState.get());
	}

	public inline function addParallelState(element:Element)
	{
		this._parallelStateMap.set(element, ParallelState.get());
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

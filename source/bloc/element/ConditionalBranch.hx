package bloc.element;

import bloc.ConditionalBranchState;

class ConditionalBranch extends DefaultElement
{
	private var _then:Element;
	private var _else:Element;

	private function new (thenElement:Element, elseElement:Element)
	{
		super();
		this._then = thenElement;
		this._else = elseElement;
	}

	override public function run(actor:Actor):Bool
	{
		var state = actor.getStateManager().getBranchState(this);
		var activeBranch = state.activeBranch;

		if (activeBranch == null) activeBranch = setActiveBranch(state);

		var completed = activeBranch.run(actor);

		if (completed)
			resetChildrenState(actor);

		return completed;
	}

	override public function toString():String
	{
		var thenStr = "then:\n" + Utility.indent(this._then.toString());
		var elseStr = "else:\n" + Utility.indent(this._else.toString());

		return Utility.indent(thenStr + "\n" + elseStr);
	}

	override public function prepareState(manager:StateManager):Void
	{
		manager.branchStateMap.set(this, new ConditionalBranchState());
		this._then.prepareState(manager);
		this._else.prepareState(manager);
	}

	public inline function resetChildrenState(actor:Actor):Void
	{
		this._then.resetState(actor);
		this._else.resetState(actor);
	}

	private function setActiveBranch(state:ConditionalBranchState):Element
	{
		state.setActiveBranch(_then);

		return _then;
	}
}

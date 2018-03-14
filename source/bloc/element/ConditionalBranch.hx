package bloc.element;

import bloc.element.ElementUtility.indent;
import bloc.state.ConditionalBranchState;

class ConditionalBranch extends DefaultElement
{
	private var _then:Pattern;
	private var _else:Pattern;

	private function new (thenPattern:Pattern, elsePattern:Pattern)
	{
		super();
		this._then = thenPattern;
		this._else = elsePattern;
	}

	override public inline function run(actor:Actor):Bool
	{
		var state = actor.getStateManager().getBranchState(this);
		var activeBranch = state.activeBranch;

		if (activeBranch == null) activeBranch = setActiveBranch(actor, state);

		var completed = activeBranch.run(actor);

		if (completed)
			resetChildrenState(actor);

		return completed;
	}

	override public function toString():String
	{
		var thenStr = "then:\n" + indent(this._then.toString());
		var elseStr = "else:\n" + indent(this._else.toString());

		return indent(thenStr + "\n" + elseStr);
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		manager.branchStateMap.set(this, new ConditionalBranchState());
		this._then.prepareState(manager);
		this._else.prepareState(manager);
	}

	override public inline function resetState(actor:Actor):Void
	{
		actor.getStateManager().getBranchState(this).reset();
	}

	public inline function resetChildrenState(actor:Actor):Void
	{
		this._then.resetState(actor);
		this._else.resetState(actor);
	}

	private function setActiveBranch(actor:Actor, state:ConditionalBranchState):Pattern
	{
		state.setActiveBranch(_then);	// dummy code to be overridden

		return _then;
	}
}

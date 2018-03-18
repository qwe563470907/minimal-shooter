package bloc.element;

import bloc.Utility.NULL_PATTERN;
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
		var str = if (this._then != NULL_PATTERN) "then:\n" + indent(this._then.toString()) else "";

		if (this._then != NULL_PATTERN && this._else != NULL_PATTERN) str += "\n";
		str += if (this._else != NULL_PATTERN) "else:\n" + indent(this._else.toString()) else "";

		return str;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		manager.addBranchState(this);
		this._then.prepareState(manager);
		this._else.prepareState(manager);
	}

	override public inline function resetState(actor:Actor):Void
	{
		actor.getStateManager().getBranchState(this).reset();
	}

	override public inline function containsWait():Bool
	{
		return this._then.containsWait() && this._else.containsWait();
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

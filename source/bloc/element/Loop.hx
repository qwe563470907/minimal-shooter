package bloc.element;

import bloc.element.ElementUtility.indent;
import bloc.state.CountState;

class Loop extends WrapperElement
{
	private var _repetitionCount:Int;

	public function new (pattern:Pattern, count:Int)
	{
		super(loop_element, pattern);
		this._repetitionCount = count;
	}

	override public inline function run(actor:Actor):Bool
	{
		var state = actor.getStateManager().getCountState(this);

		while (!state.isCompleted)
		{
			var completed = this._pattern.run(actor);

			if (!completed) return false;

			this.resetChildState(actor);
			state.increment();
		}

		return true;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		super.prepareState(manager);
		manager.countStateMap.set(this, new CountState(this._repetitionCount));
	}

	override public inline function resetState(actor:Actor):Void
	{
		actor.getStateManager().getCountState(this).reset();
	}

	override public function toString():String
	{
		var content = "count: " + this._repetitionCount + "\npattern:\n" + indent(this._pattern.toString());

		return "loop:\n" + indent(content);
	}
}

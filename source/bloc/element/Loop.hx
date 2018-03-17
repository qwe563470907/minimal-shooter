package bloc.element;

import bloc.element.ElementUtility.indent;
import bloc.state.CountState;

class Loop extends DefaultElement
{
	private var _pattern:Pattern;
	private var _repetitionCount:Int;

	public function new (pattern:Pattern, count:Int)
	{
		super();
		this._pattern = pattern;
		this._repetitionCount = count;
	}

	override public inline function run(actor:Actor):Bool
	{
		var state = actor.getStateManager().getCountState(this);

		while (!state.isCompleted)
		{
			var completed = this._pattern.run(actor);

			if (!completed) return false;

			this._pattern.resetState(actor);
			state.increment();
		}

		return true;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		manager.countStateMap.set(this, new CountState(this._repetitionCount));
		this._pattern.prepareState(manager);
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

	override public inline function containsWait():Bool
	{
		return this._pattern.containsWait();
	}
}

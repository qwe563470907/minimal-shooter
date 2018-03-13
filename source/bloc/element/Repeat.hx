package bloc.element;

import bloc.state.CountState;

class Repeat extends DefaultElement
{
	public var element:Pattern;
	private var repetitionCount:Int;

	public function new (element:Pattern, count:Int)
	{
		super();
		this.element = element;
		this.repetitionCount = count;
	}

	override public inline function run(actor:Actor):Bool
	{
		var state = actor.getStateManager().getCountState(this);

		while (!state.isCompleted)
		{
			var completed = this.element.run(actor);

			if (!completed) return false;

			this.element.resetState(actor);
			state.increment();
		}

		return true;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		manager.countStateMap.set(this, new CountState(this.repetitionCount));
		this.element.prepareState(manager);
	}

	override public inline function resetState(actor:Actor):Void
	{
		actor.getStateManager().getCountState(this).reset();
	}
}

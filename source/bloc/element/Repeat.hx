package bloc.element;

class Repeat extends DefaultElement
{
	public var action:Element;
	private var repetitionCount:Int;

	public function new (action:Element, count:Int)
	{
		super();
		this.action = action;
		this.repetitionCount = count;
	}

	override public function run(actor:Actor):Bool
	{
		var state = actor.getStateManager().getCountState(this);

		while (!state.isCompleted)
		{
			var completed = this.action.run(actor);

			if (!completed) return false;

			this.action.resetState(actor);
			state.increment();
		}

		return true;
	}

	override public function prepareState(manager:StateManager):Void
	{
		manager.countStateMap.set(this, new CountState(this.repetitionCount));
		this.action.prepareState(manager);
	}

	override public function resetState(actor:Actor):Void
	{
		actor.getStateManager().getCountState(this).reset();
	}
}

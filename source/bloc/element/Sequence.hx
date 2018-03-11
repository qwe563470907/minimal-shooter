package bloc.element;

class Sequence extends List
{
	public function new (actionList:Array<Element>)
	{
		super(actionList);
	}

	override public function run(actor:Actor):Bool
	{
		var state = actor.getStateManager().getCountState(this);

		while (!state.isCompleted)
		{
			var completed = this.actionList[state.count].run(actor);

			if (!completed) return false;

			state.increment();
		}

		this.resetChildrenState(actor);

		return true;
	}

	override public function prepareState(manager:StateManager):Void
	{
		super.prepareState(manager);

		var actionListLength = this.actionList.length;
		manager.addCountState(this, actionListLength);
	}

	override public function resetState(actor:Actor):Void
	{
		actor.getStateManager().getCountState(this).reset();
	}

	override public function toString():String
	{
		return "sequence:\n" + super.toString();
	}
}

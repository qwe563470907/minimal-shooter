package bloc.element;

import bloc.element.ElementUtility.indent;

class Parallel extends List
{
	public function new (elements:Array<Element>)
	{
		super(elements);
	}

	override public inline function run(actor:Actor):Bool
	{
		var completedAll = true;

		var state = actor.getStateManager().getParallelState(this);

		for (element in this.elements)
		{
			if (state.hasCompleted(element) == true)
				continue;

			if (element.run(actor))
				state.setCompleted(element);
			else
				completedAll = false;
		}

		if (completedAll) this.resetChildrenState(actor);

		return completedAll;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		super.prepareState(manager);
		manager.addParallelState(this);
	}

	override public inline function resetState(actor:Actor):Void
	{
		actor.getStateManager().getParallelState(this).reset();
	}

	override public function toString():String
	{
		return "parallel:\n" + indent(super.toString());
	}
}

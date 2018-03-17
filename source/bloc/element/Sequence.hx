package bloc.element;

import bloc.element.ElementUtility.indent;

class Sequence extends List
{
	public function new (elements:Array<Element>)
	{
		super(elements);
	}

	override public function run(actor:Actor):Bool
	{
		var state = actor.getStateManager().getCountState(this);

		while (!state.isCompleted)
		{
			var completed = this.elements[state.count].run(actor);

			if (!completed) return false;

			state.increment();
		}

		this.resetChildrenState(actor);

		return true;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		super.prepareState(manager);

		var elementsLength = this.elements.length;
		manager.addCountState(this, elementsLength);
	}

	override public inline function resetState(actor:Actor):Void
	{
		actor.getStateManager().getCountState(this).reset();
	}

	override public function toString():String
	{
		return "sequence:\n" + indent(super.toString());
	}
}

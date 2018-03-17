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

		for (i in 0...this.elements.length)
			completedAll = this.elements[i].run(actor) && completedAll;

		if (completedAll) this.resetChildrenState(actor);

		return completedAll;
	}

	override public function toString():String
	{
		return "parallel:\n" + indent(super.toString());
	}
}

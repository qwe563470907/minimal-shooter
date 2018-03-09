package bloc.element;

class Parallel extends List
{
	public function new (actionList: Array<Element>)
	{
		super(actionList);
	}

	override public function run(actor: IActor): Bool
	{
		var completedAll = true;

		for (i in 0...this.actionList.length)
			completedAll = this.actionList[i].run(actor) && completedAll;

		if (completedAll) this.resetChildrenState(actor);

		return completedAll;
	}

	override public function toString(): String
	{
		return "parallel:\n" + super.toString();
	}
}

package bloc.element;

class List extends DefaultElement
{
	public var actionList:Array<Element>;

	private function new (actionList:Array<Element>)
	{
		super();
		this.actionList = actionList.copy();
	}

	public function resetChildrenState(actor:Actor):Void
	{
		for (i in 0...this.actionList.length)
			this.actionList[i].resetState(actor);
	}

	override public function prepareState(manager:StateManager):Void
	{
		for (i in 0...this.actionList.length)
			this.actionList[i].prepareState(manager);
	}

	override public function toString():String
	{
		var str = "  ";
		var len = this.actionList.length;

		for (i in 0...len)
			str += this.actionList[i].toString() + if (i < len - 1) "\n" else "";

		return StringTools.replace(str, "\n", "\n  ");
	}
}

package bloc.element;

class List extends DefaultElement
{
	public var elements:Array<Element>;

	private function new (elements:Array<Element>)
	{
		super();
		this.elements = elements.copy();
	}

	public function resetChildrenState(actor:Actor):Void
	{
		for (i in 0...this.elements.length)
			this.elements[i].resetState(actor);
	}

	override public function prepareState(manager:StateManager):Void
	{
		for (i in 0...this.elements.length)
			this.elements[i].prepareState(manager);
	}

	override public function toString():String
	{
		return this.render();
	}

	override public inline function containsWait():Bool
	{
		var result = false;

		for (element in this.elements)
		{
			if (element.containsWait())
			{
				result = true;
				break;
			}
		}

		return result;
	}

	private inline function render():String
	{
		var str = "";
		var len = this.elements.length;

		for (i in 0...len)
			str += this.elements[i].toString() + if (i < len - 1) "\n" else "";

		return str;
	}
}

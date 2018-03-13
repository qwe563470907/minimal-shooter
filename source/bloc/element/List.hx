package bloc.element;

import bloc.element.ElementUtility.indent;

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
		var str = "";
		var len = this.elements.length;

		for (i in 0...len)
			str += this.elements[i].toString() + if (i < len - 1) "\n" else "";

		return indent(str);
	}
}

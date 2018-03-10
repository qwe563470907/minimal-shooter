package bloc.element;

class IfBranch extends ConditionalBranch
{
	private var _expression:String;

	public function new (expression:String, thenElement:Element, elseElement:Element)
	{
		super(thenElement, elseElement);
		this._expression = expression;
	}

	override public function toString():String
	{
		var expStr = "expression:\n" + Utility.indent(this._expression);

		return "if:\n" + Utility.indent(expStr) + "\n" + super.toString();
	}

	override private function setActiveBranch(state:ConditionalBranchState):Element
	{
		state.setActiveBranch(_then);

		return _then;
	}
}

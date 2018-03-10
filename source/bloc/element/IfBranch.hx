package bloc.element;

class IfBranch extends ConditionalBranch
{
	static private var parser = new hscript.Parser();
	static private var interpreter = new hscript.Interp();

	private var _expression:String;
	private var _parsedExpression:hscript.Expr;

	public function new (expression:String, thenElement:Element, elseElement:Element)
	{
		super(thenElement, elseElement);
		this._expression = expression;
		this._parsedExpression = parser.parseString(expression);
	}

	override public function toString():String
	{
		var expStr = "expression:\n" + Utility.indent(this._expression);

		return "if:\n" + Utility.indent(expStr) + "\n" + super.toString();
	}

	override private function setActiveBranch(state:ConditionalBranchState):Element
	{
		var evaluationResult = interpreter.execute(this._parsedExpression);
		trace(evaluationResult);

		if (Std.is(evaluationResult, Bool) == false)
		{
			trace("Failed to evaluate expression: " + _expression);
			evaluationResult = false;
		}

		var branch = if (evaluationResult) _then else _else;

		state.setActiveBranch(branch);

		return branch;
	}
}

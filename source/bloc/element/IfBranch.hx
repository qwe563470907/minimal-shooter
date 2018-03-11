package bloc.element;

import bloc.element.ElementUtility.indent;
import bloc.state.ConditionalBranchState;

class IfBranch extends ConditionalBranch
{
	static private var _parser = new hscript.Parser();

	private var _interpreter:hscript.Interp;
	private var _expression:String;
	private var _parsedExpression:hscript.Expr;
	private var _command:String;
	private var _hasExpression:Bool;
	private var _hasCommand:Bool;

	public function new (expression:Null<String>, command:Null<String>, thenElement:Element, elseElement:Element)
	{
		super(thenElement, elseElement);

		if (expression != null)
		{
			this._interpreter = new hscript.Interp();
			this._expression = expression;
			this._parsedExpression = _parser.parseString(expression);
			this._hasExpression = true;
		}
		else this._hasExpression = false;

		if (command != null)
		{
			this._command = command;
			this._hasCommand = true;
		}
		else this._hasCommand = false;
	}

	override public function toString():String
	{
		var str = "";

		if (this._hasExpression)
		{
			str = "expression:\n" + indent(this._expression);

			if (this._hasCommand) str += "\n";
		}

		if (this._hasCommand)
			str += "command:\n" + indent(this._command);

		return "if:\n" + indent(str) + "\n" + super.toString();
	}

	override private function setActiveBranch(actor:Actor, state:ConditionalBranchState):Element
	{
		var expEvalResult:Bool;

		if (this._hasExpression)
		{
			expEvalResult = this._interpreter.execute(this._parsedExpression);

			if (Std.is(expEvalResult, Bool) == false)
			{
				trace("Failed to evaluate expression: " + this._expression);
				expEvalResult = false;
			}
		}
		else
			expEvalResult = false;

		var cmdEvalResult = if (this._hasCommand) actor.hasReceivedCommand(this._command) else false;

		var branch = if (expEvalResult || cmdEvalResult) this._then else this._else;

		state.setActiveBranch(branch);

		return branch;
	}
}

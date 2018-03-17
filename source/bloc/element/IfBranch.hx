package bloc.element;

import bloc.element.ElementUtility.indent;
import bloc.state.ConditionalBranchState;

class IfBranch extends ConditionalBranch
{
	static private var _parser = new hscript.Parser();

	private var _interpreter:hscript.Interp;
	private var _expression:String;
	private var _parsedExpression:hscript.Expr;
	private var _commandText:String;
	private var _hasExpression:Bool;
	private var _hasCommand:Bool;

	public function new (expression:Null<String>, commandText:Null<String>, thenPattern:Pattern, elsePattern:Pattern)
	{
		super(thenPattern, elsePattern);

		if (expression != null)
		{
			this._interpreter = new hscript.Interp();
			this._expression = expression;
			this._parsedExpression = _parser.parseString(expression);
			this._hasExpression = true;
		}
		else this._hasExpression = false;

		if (commandText != null)
		{
			this._commandText = commandText;
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
			str += "command:\n" + indent(this._commandText.toString());

		return "if:\n" + indent(str) + "\n" + indent(super.toString());
	}

	override private inline function setActiveBranch(actor:Actor, state:ConditionalBranchState):Pattern
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

		var cmdEvalResult = if (this._hasCommand) actor.hasReceivedCommand(this._commandText) else false;

		var branch = if (expEvalResult || cmdEvalResult) this._then else this._else;

		state.setActiveBranch(branch);

		return branch;
	}
}

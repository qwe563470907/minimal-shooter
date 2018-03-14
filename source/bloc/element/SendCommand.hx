package bloc.element;

class SendCommand extends DefaultElement
{
	private var _command:Command;

	public function new (commandText:String)
	{
		super();
		this._command = new Command(commandText);
	}

	override public inline function run(actor:Actor):Bool
	{
		actor.sendCommand(this._command);

		return true;
	}

	override public function toString():String
	{
		return "command: " + this._command.toString();
	}
}

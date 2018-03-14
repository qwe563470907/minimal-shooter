package bloc;

class Command
{
	public var commandText(default, null):String;

	public function new (commandText:String)
	{
		this.commandText = commandText;
	}

	public inline function toString():String
	{
		return this.commandText;
	}
}

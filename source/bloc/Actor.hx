package bloc;

interface Actor
{
	public function getStateManager():StateManager;
	// public function getPosition():Vector;
	public function setPosition(x:Float, y:Float):Void;
	// public function getVelocity():Vector;
	public function setVelocity(x:Float, y:Float):Void;
	public function addVelocity(x:Float, y:Float):Void;
	public function fire(pattern:Pattern):Actor;
	public function kill():Void;

	/**
	 *  Checks if this actor has recently received the specified command string.
	 *
	 *  @param   String command
	 *  @return  True if received.
	 */
	public function hasReceivedCommand(command:String):Bool;
}

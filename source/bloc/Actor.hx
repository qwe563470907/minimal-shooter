package bloc;

interface Actor
{
	public var position(get, never):Vector;
	public var motionVelocity(get, never):Vector;
	public var shotPosition(get, never):Vector;
	public var shotVelocity(get, never):Vector;
	// Vector reference for shot_position and shot_velocity ???

	public function getStateManager():StateManager;
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

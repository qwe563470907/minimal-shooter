package bloc;

using tink.core.Ref;

interface Actor
{
	public var position(get, never):Vector;
	public var velocity(get, never):Vector;
	public var shotPosition(get, never):Vector;
	public var shotVelocity(get, never):Vector;

	public var bearingAngularVelocity(get, never):Ref<AngleInterval>;
	public var directionAngularVelocity(get, never):Ref<AngleInterval>;
	public var shotBearingAngularVelocity(get, never):Ref<AngleInterval>;
	public var shotDirectionAngularVelocity(get, never):Ref<AngleInterval>;

	public function getStateManager():StateManager;
	public function fire(pattern:Pattern):Actor;
	public function kill():Void;

	/**
	 * Sends the specified command.
	 * The receiver actor will receive the command from the last of the current frame to the beginning of the next frame.
	 *
	 * @param   command The command to send.
	 */
	public function sendCommand(command:Command):Void;

	/**
	 *  Checks if this actor has recently received the specified command text.
	 *
	 *  @param   commandText The command text to check.
	 *  @return  True if received.
	 */
	public function hasReceivedCommand(commandText:String):Bool;
}

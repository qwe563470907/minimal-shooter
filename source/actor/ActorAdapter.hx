package actor;

import bloc.Pattern;
import bloc.Utility;
import bloc.StateManager;
import bloc.Vector;
import haxe.ds.StringMap;

// private class TemporalVector implements Vector
// {
// 	public var x:Float;
// 	public var y:Float;

// 	public function new (x:Float, y:Float)
// 	{
// 		this.x = x;
// 		this.y = y;
// 	}
// }

/**
 * Adapter for Actor class and BLOC package.
 */
class ActorAdapter implements bloc.Actor
{
	// static private var _temporalVector:Vector = new TemporalVector(0, 0);

	public var position(get, never):Vector;
	public var motionVelocity(get, never):Vector;

	private var _actor:ActorSprite;
	private var _blocPattern:Pattern;
	private var _blocStateManager:StateManager;
	private var _receivedMessages:StringMap<Bool>;

	public function new (actor:ActorSprite)
	{
		this._actor = actor;
		this._blocStateManager = new StateManager();
		this._blocPattern = Utility.NULL_PATTERN;
		this._receivedMessages = new StringMap<Bool>();
	}

	public function fire(pattern:Pattern):bloc.Actor
	{
		this._actor.fire(pattern);

		return this;
	}

	public function kill():Void
	{ this._actor.kill(); }

	public function runBulletHellPattern():Void
	{
		this._blocPattern.run(this);

		for (message in _receivedMessages.keys())
			_receivedMessages.remove(message);
	}

	/**
	 * Receives and stores the specified command string.
	 * The received commands will be cleared every time after running the BLOC pattern.
	 *
	 * @param   String command
	 */
	public inline function receiveCommand(command:String):Void
	{
		this._receivedMessages.set(command, true);
	}

	public inline function hasReceivedCommand(command:String):Bool
	{
		return this._receivedMessages.exists(command);
	}

	public function getStateManager():StateManager
	{ return _blocStateManager; }

	public function setBlocPattern(v:Pattern):Void
	{
		v.prepareState(this._blocStateManager);
		this._blocPattern = v;
	}

	inline function get_position()
	{
		return this._actor.position;
	}

	inline function get_motionVelocity()
	{
		return this._actor.motionVelocity;
	}
}

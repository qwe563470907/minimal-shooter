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
	public var shotVelocity(get, never):Vector;

	private var _actor:ActorSprite;
	private var _blocPattern:Pattern;
	private var _blocStateManager:StateManager;
	private var _receivedCommands:StringSet;

	public function new (actor:ActorSprite)
	{
		this._actor = actor;
		this._blocStateManager = new StateManager();
		this._blocPattern = Utility.NULL_PATTERN;
		this._receivedCommands = new StringSet();
	}

	public inline function reset():Void
	{
		this._blocStateManager.clear();
		this._blocPattern = Utility.NULL_PATTERN;
		this._receivedCommands.clear();
	}

	public inline function fire(pattern:Pattern):bloc.Actor
	{
		this._actor.fire(pattern);

		return this;
	}

	public inline function kill():Void
	{ this._actor.kill(); }

	public inline function runBulletHellPattern():Void
	{
		this._blocPattern.run(this);
		this._receivedCommands.clear();
	}

	/**
	 * Receives and stores the specified command string.
	 * The received commands will be cleared every time after running the BLOC pattern.
	 *
	 * @param   String command
	 */
	public inline function receiveCommand(command:String):Void
	{
		this._receivedCommands.add(command);
	}

	public inline function hasReceivedCommand(command:String):Bool
	{
		return this._receivedCommands.exists(command);
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

	inline function get_shotVelocity()
	{
		return this._actor.shotVelocity;
	}
}

class StringSet extends StringMap<Bool>
{
	public function new ()
	{
		super();
	}

	public inline function add(key:String)
	{
		this.set(key, true);
	}

	public inline function clear():Void
	{
		for (key in this.keys())
			this.remove(key);
	}
}

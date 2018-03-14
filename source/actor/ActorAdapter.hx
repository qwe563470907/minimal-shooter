package actor;

import bloc.Pattern;
import bloc.Utility;
import bloc.Vector;
import bloc.StateManager;
import bloc.Command;

/**
 * Adapter for Actor class and BLOC package.
 */
class ActorAdapter implements bloc.Actor
{
	public var position(get, never):Vector;
	public var velocity(get, never):Vector;
	public var shotPosition(get, never):Vector;
	public var shotVelocity(get, never):Vector;

	private var _actor:ActorSprite;
	private var _blocPattern:Pattern;
	private var _blocStateManager:StateManager;
	private var _receivedCommandTextSet:StringSet;

	public function new (actor:ActorSprite)
	{
		this._actor = actor;
		this._blocStateManager = new StateManager();
		this._blocPattern = Utility.NULL_PATTERN;
		this._receivedCommandTextSet = new StringSet();
	}

	public inline function reset():Void
	{
		this._blocStateManager.clear();
		this._blocPattern = Utility.NULL_PATTERN;
		this._receivedCommandTextSet.clear();
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

		this._receivedCommandTextSet.clear();
	}

	public function sendCommand(command:Command):Void
	{
		this._actor.army.registerCommand(command);
	}

	/**
	 * Receives and stores the specified command.
	 * The received commands will be cleared every time after running the BLOC pattern.
	 *
	 * @param   command
	 */
	public inline function receiveCommand(command:Command):Void
	{
		this._receivedCommandTextSet.add(command.commandText);
	}

	public inline function hasReceivedCommand(commandText:String):Bool
	{
		return this._receivedCommandTextSet.exists(commandText);
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

	inline function get_velocity()
	{
		return this._actor.motionVelocity;
	}

	inline function get_shotPosition()
	{
		return this._actor.shotPosition;
	}

	inline function get_shotVelocity()
	{
		return this._actor.shotVelocity;
	}
}

class StringSet extends haxe.ds.StringMap<Bool>
{
	private var _keys:Array<String>;

	public function new ()
	{
		super();
		this._keys = [];
	}

	public inline function add(key:String)
	{
		this.set(key, true);
		this._keys.push(key);
	}

	public inline function clear():Void
	{
		while (this._keys.length > 0)
			this.remove(this._keys.pop());
	}
}

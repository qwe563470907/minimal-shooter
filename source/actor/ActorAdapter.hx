package actor;

using tink.core.Ref;
import de.polygonal.ds.ArrayedQueue;
import bloc.Pattern;
import bloc.Utility;
import bloc.Vector;
import bloc.AngleInterval;
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

	public var bearingAngularVelocity(get, never):Ref<AngleInterval>;
	public var directionAngularVelocity(get, never):Ref<AngleInterval>;
	public var shotBearingAngularVelocity(get, never):Ref<AngleInterval>;
	public var shotDirectionAngularVelocity(get, never):Ref<AngleInterval>;

	public var hasCompletedPattern:Bool;

	private var _actor:ActorSprite;
	private var _blocPattern:Pattern;
	private var _blocStateManager:StateManager;
	private var _receivedCommandTextSet:StringSet;
	private var _blocSubThreads:ArrayedQueue<Pattern>;

	public function new (actor:ActorSprite)
	{
		this.hasCompletedPattern = false;

		this._actor = actor;
		this._blocStateManager = new StateManager();
		this._blocPattern = Utility.NULL_PATTERN;
		this._receivedCommandTextSet = new StringSet();
		this._blocSubThreads = new ArrayedQueue<Pattern>(10);
		this._blocSubThreads.reuseIterator = true;
	}

	public inline function reset():Void
	{
		this._blocStateManager.clear();
		this._blocPattern = Utility.NULL_PATTERN;
		this._receivedCommandTextSet.clear();
		this.hasCompletedPattern = false;
	}

	public inline function fire(pattern:Pattern, bind:Bool):bloc.Actor
	{
		this._actor.fire(pattern, bind);

		return this;
	}

	public inline function kill():Void
	{ this._actor.kill(); }

	public inline function runBulletHellPattern():Void
	{
		if (!this.hasCompletedPattern)
		{
			this.hasCompletedPattern = this._blocPattern.run(this);
			this._receivedCommandTextSet.clear();
		}

		for (thread in this._blocSubThreads)
		{
			if (thread.run(this))
				this._blocSubThreads.dequeue();
		}
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

	public function addSubThreadPattern(pattern:Pattern):Void
	{
		this._blocSubThreads.enqueue(pattern);
	}

	inline function get_position()
	{ return this._actor.position; }

	inline function get_velocity()
	{ return this._actor.motionVelocity; }

	inline function get_shotPosition()
	{ return this._actor.shotPosition; }

	inline function get_shotVelocity()
	{ return this._actor.shotVelocity; }

	inline function get_bearingAngularVelocity()
	{ return this._actor.bearingAngularVelocity; }

	inline function get_directionAngularVelocity()
	{ return this._actor.directionAngularVelocity; }

	inline function get_shotBearingAngularVelocity()
	{ return this._actor.shotBearingAngularVelocity; }

	inline function get_shotDirectionAngularVelocity()
	{ return this._actor.shotDirectionAngularVelocity; }
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

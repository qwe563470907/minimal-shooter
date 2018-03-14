package actor;

import flixel.FlxBasic;
import flixel.FlxState;
import flixel.group.FlxGroup;
import bloc.Command;

class ActorArmy extends FlxBasic
{
	public var agents:FlxTypedGroup<Agent>;
	public var bullets:FlxTypedGroup<Bullet>;
	private var _commands:Array<Command>;

	public function new (state:FlxState, agentCapacity:Int, bulletCapacity:Int, agentFactory:Void->Agent, bulletFactory:Void->Bullet)
	{
		super();

		agents = new FlxTypedGroup<Agent>(agentCapacity);

		for (i in 0...agentCapacity)
		{
			var agent = agentFactory();
			agent.army = this;
			agents.add(agent);
		}

		state.add(agents);

		bullets = new FlxTypedGroup<Bullet>(bulletCapacity);

		for (i in 0...bulletCapacity)
		{
			var bullet = bulletFactory();
			bullet.army = this;
			bullets.add(bullet);
		}

		state.add(bullets);

		_commands = [];
		state.add(this);
	}

	override public function update(elapsed:Float):Void
	{
		for (agent in agents)
		{
			for (command in _commands)
				agent.adapter.receiveCommand(command);
		}

		for (bullet in bullets)
		{
			for (command in _commands)
				bullet.adapter.receiveCommand(command);
		}

		while (_commands.length > 0)
			_commands.pop();

		super.update(elapsed);
	}

	public inline function registerCommand(command:Command):Void
	{
		_commands.push(command);
	}

	public inline function newAgent():Agent
	{
		var agent = agents.recycle(null, null, false, true);
		agent.resetContents();

		return agent;
	}

	public inline function newBullet():Bullet
	{
		var bullet = bullets.recycle(null, null, false, true);
		bullet.resetContents();

		return bullet;
	}
}

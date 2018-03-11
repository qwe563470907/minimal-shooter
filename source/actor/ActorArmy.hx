package actor;

import flixel.group.FlxGroup;
import flixel.FlxState;

class ActorArmy
{
	public var agents:FlxTypedGroup<Agent>;
	public var bullets:FlxTypedGroup<Bullet>;

	public function new (state:FlxState, agentCapacity:Int, bulletCapacity:Int, agentFactory:Void->Agent, bulletFactory:Void->Bullet)
	{
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

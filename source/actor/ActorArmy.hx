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
			agents.add(agentFactory());

		state.add(agents);

		bullets = new FlxTypedGroup<Bullet>(bulletCapacity);

		for (i in 0...bulletCapacity)
			bullets.add(bulletFactory());

		state.add(bullets);
	}

	public inline function newAgent():Agent
	{
		var agent = agents.recycle(null, null, false, true);
		agent.army = this;

		return agent;
	}

	public inline function newBullet():Bullet
	{
		var bullet = bullets.recycle(null, null, false, true);
		bullet.army = this;

		return bullet;
	}
}

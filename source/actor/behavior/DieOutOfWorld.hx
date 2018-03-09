package actor.behavior;

class DieOutOfWorld implements Behavior
{
	var margin: Float;

	public function new (Margin: Float)
	{
		margin = Margin;
	}

	public function run(actor: ActorSprite): Void
	{
		if (actor.isOutOfWorld(margin))
			actor.kill();
	}
}

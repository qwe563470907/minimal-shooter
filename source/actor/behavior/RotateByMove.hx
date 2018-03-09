package actor.behavior;

import flixel.FlxG;

class RotateByMove implements Behavior
{
	var standardSpeed: Float;
	var standardAngularVelocity: Float;

	public function new (StandardSpeed: Float, StandardAngularVelocity: Float)
	{
		standardSpeed = StandardSpeed;
		standardAngularVelocity = StandardAngularVelocity;
	}

	public function run(actor: ActorSprite): Void
	{
		actor.angle += (standardAngularVelocity / FlxG.updateFramerate) * (actor.motionVelocity.radius / standardSpeed);
	}
}

package actor;

import flixel.FlxSprite;
// import flixel.math.FlxPoint;
// import flixel.util.FlxArrayUtil.clearArray;
import flixel.FlxG;
import actor.behavior.*;
import bloc.Pattern;

class ActorSprite extends FlxSprite // implements ICleanable
{
	public var army: ActorArmy;

	public var motionVelocity: Vector;
	public var shotOffset: Vector;

	public var properFrameCount: Int = 0;
	public var centerX(get, set): Float;
	public var centerY(get, set): Float;
	// public var childActors:CleanableGroup<Actor>;

	private var behaviorList: Array<Behavior>;
	private var adapter: ActorAdapter;

	public function new ()
	{
		super();
		super.kill();
		behaviorList = [];
		adapter = new ActorAdapter(this);
		// childActors = new CleanableGroup<Actor>(256);
		motionVelocity = new Vector();
		shotOffset = new Vector();
	}

	// public function clean():Void
	// {
	// 	childActors.clean();
	// }

	public inline function addBehavior(Behavior: Behavior)
	{
		behaviorList.push(Behavior);
	}

	public inline function truncateSpeed(max: Float): Void
	{
		if (motionVelocity.radius > max)
			motionVelocity.radius = max;
	}

	/**
	 * Check and see if this object is currently out of the world bounds.
	 *
	 * @param	margin	The margin around the world bounds.
	 * @return   True if the object is out of the world.
	 */
	public inline function isOutOfWorld(margin: Float = 0): Bool
	{
		return (x + width < FlxG.worldBounds.x - margin) || (x > FlxG.worldBounds.right + margin) ||
		(y + height < FlxG.worldBounds.y - margin) || (y > FlxG.worldBounds.bottom + margin);
	}

	override public function update(elapsed: Float): Void
	{
		velocity.set(motionVelocity.x, motionVelocity.y);
		super.update(elapsed);
		motionVelocity.setCartesian(velocity.x, velocity.y);

		for (behavior in behaviorList)
			behavior.run(this);

		adapter.runBulletHellPattern();
		properFrameCount++;
		// childActors.forEach(removeNonExistingChild);

		velocity.set(motionVelocity.x, motionVelocity.y);
	}

	override public function kill(): Void
	{
		super.kill();
		setPosition(-10000, -10000);
		// clearArray(behaviorList, false);
	}

	// private function removeNonExistingChild(A:Actor):Void {
	// 	if(!A.exists)
	// 		childActors.remove(A, true);
	// }

	/**
	 * Loads graphics.
	 * @param   Graphic		The file name.
	 * @param   Rotation	Set `true` for calling `loadRotatedGraphic()`.
	 * @return  This `FlxSprite` instance.
	 */
	public inline function setGraphic(Graphic: String, ? Rotations : Int): flixel.FlxSprite
	{
		if (Rotations != null)
			loadRotatedGraphic(Graphic, Rotations, -1, true, true);
		else
			loadGraphic(Graphic);

		return this;
	}

	public inline function setCenterPosition(x: Float = 0, y: Float = 0): Void
	{
		centerX = x;
		centerY = y;
	}

	public inline function fire(speed: Float, direction: Float): ActorSprite
	{
		var newBullet = army.newBullet();
		newBullet.setCenterPosition(centerX + shotOffset.x, centerY + shotOffset.y);
		newBullet.motionVelocity.setPolar(speed, direction);
		return this;
	}

	function get_centerX()
	{
		return x + 0.5 * width;
	}

	function get_centerY()
	{
		return y + 0.5 * height;
	}

	function set_centerX(v: Float)
	{
		return x = v - 0.5 * width;
	}

	function set_centerY(v: Float)
	{
		return y = v - 0.5 * height;
	}

	public function setActionPattern(v: Pattern): Void
	{
		this.adapter.setActionPattern(v);
	}
}

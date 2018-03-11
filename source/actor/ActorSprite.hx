package actor;

import flixel.FlxSprite;
// import flixel.math.FlxPoint;
// import flixel.util.FlxArrayUtil.clearArray;
import flixel.FlxG;
import actor.behavior.*;
import bloc.Pattern;

class ActorSprite extends FlxSprite // implements ICleanable
{
	public var army:ActorArmy;

	public var position:Vector;
	public var motionVelocity:Vector;
	public var shotOffset:Vector;

	public var halfWidth:Float;
	public var halfHeight:Float;

	public var properFrameCount:Int = 0;
	// public var childActors:CleanableGroup<Actor>;

	private var behaviorList:Array<Behavior>;
	public var adapter:ActorAdapter;

	public function new ()
	{
		super();
		super.kill();
		behaviorList = [];
		adapter = new ActorAdapter(this);
		// childActors = new CleanableGroup<Actor>(256);
		position = new Vector();
		motionVelocity = new Vector();
		shotOffset = new Vector();
	}

	// public function clean():Void
	// {
	// 	childActors.clean();
	// }

	public inline function addBehavior(Behavior:Behavior)
	{
		behaviorList.push(Behavior);
	}

	public inline function truncateSpeed(max:Float):Void
	{
		if (motionVelocity.length > max)
			motionVelocity.length = max;
	}

	/**
	 * Check and see if this object is currently out of the world bounds.
	 *
	 * @param	margin	The margin around the world bounds.
	 * @return   True if the object is out of the world.
	 */
	public inline function isOutOfWorld(margin:Float = 0):Bool
	{
		return (position.x + halfWidth < FlxG.worldBounds.x - margin) || (position.x - halfWidth > FlxG.worldBounds.right + margin) ||
		(position.y + halfHeight < FlxG.worldBounds.y - margin) || (position.y - halfHeight > FlxG.worldBounds.bottom + margin);
	}

	override public function update(elapsed:Float):Void
	{
		this.halfWidth = 0.5 * this.width;
		this.halfHeight = 0.5 * this.height;

		// Sync vectors between flixel and BLOC.
		setPosition(position.x - halfWidth, position.y - halfHeight);
		velocity.set(motionVelocity.x, motionVelocity.y);
		super.update(elapsed);
		position.setCartesian(x + halfWidth, y + halfHeight);
		motionVelocity.setCartesian(velocity.x, velocity.y);

		for (behavior in behaviorList)
			behavior.run(this);

		adapter.runBulletHellPattern();
		properFrameCount++;
		// childActors.forEach(removeNonExistingChild);
	}

	override public function kill():Void
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
	public inline function setGraphic(Graphic:String, ?Rotations:Int):flixel.FlxSprite
	{
		if (Rotations != null)
			loadRotatedGraphic(Graphic, Rotations, -1, true, true);
		else
			loadGraphic(Graphic);

		return this;
	}

	public inline function fire(pattern:Pattern):ActorSprite
	{
		var newBullet = army.newBullet();
		newBullet.position.set(this.position);
		newBullet.motionVelocity.setCartesian(0, 0);
		newBullet.setActionPattern(pattern);

		return this;
	}

	public function setActionPattern(v:Pattern):Void
	{
		this.adapter.setActionPattern(v);
	}
}

package actor;

using tink.core.Ref;
import flixel.FlxSprite;
// import flixel.math.FlxPoint;
// import flixel.util.FlxArrayUtil.clearArray;
import flixel.FlxG;
import actor.behavior.*;
import bloc.Pattern;
import bloc.AngleInterval;

class ActorSprite extends FlxSprite // implements ICleanable
{
	public var army:ActorArmy;

	public var position:Vector;
	public var motionVelocity:Vector;
	public var shotPosition:Vector;
	public var shotVelocity:Vector;

	public var bearingAngularVelocity:Ref<AngleInterval>;
	public var directionAngularVelocity:Ref<AngleInterval>;
	public var shotBearingAngularVelocity:Ref<AngleInterval>;
	public var shotDirectionAngularVelocity:Ref<AngleInterval>;

	public var halfWidth:Float;
	public var halfHeight:Float;

	public var properFrameCount:Int = 0;
	// public var childActors:CleanableGroup<Actor>;

	private var behaviorList:Array<Behavior>;
	public var adapter:ActorAdapter;

	private var absolutePosition:Vector;
	private var isBinded:Bool;

	public function new ()
	{
		super();
		super.kill();
		behaviorList = [];
		adapter = new ActorAdapter(this);
		// childActors = new CleanableGroup<Actor>(256);

		position = new Vector();
		motionVelocity = new Vector();
		shotPosition = new Vector();
		shotPosition.setRelativeReference(position);	// relative vector at default
		shotVelocity = new Vector();

		bearingAngularVelocity = AngleInterval.fromZero();
		directionAngularVelocity = AngleInterval.fromZero();
		shotBearingAngularVelocity = AngleInterval.fromZero();
		shotDirectionAngularVelocity = AngleInterval.fromZero();

		absolutePosition = new Vector();
		isBinded = false;
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
		position.calculateAbsolute(absolutePosition);

		return (absolutePosition.x + halfWidth < FlxG.worldBounds.x - margin) || (absolutePosition.x - halfWidth > FlxG.worldBounds.right + margin) ||
		(absolutePosition.y + halfHeight < FlxG.worldBounds.y - margin) || (absolutePosition.y - halfHeight > FlxG.worldBounds.bottom + margin);
	}

	override public function update(elapsed:Float):Void
	{
		this.halfWidth = 0.5 * this.width;
		this.halfHeight = 0.5 * this.height;

		for (behavior in behaviorList)
			behavior.run(this);

		adapter.runBulletHellPattern();
		applyAngularVelocities();
		properFrameCount++;
		// childActors.forEach(removeNonExistingChild);

		syncBlocToFlixel();
		super.update(elapsed);
		syncFlixelToBloc();
	}

	public inline function syncBlocToFlixel():Void
	{
		position.calculateAbsolute(absolutePosition);
		setPosition(absolutePosition.x - halfWidth, absolutePosition.y - halfHeight);
		velocity.set(motionVelocity.x * 60, motionVelocity.y * 60);
	}

	public inline function syncFlixelToBloc():Void
	{
		// Is it really OK????

		if (this.isBinded)
			position.add(motionVelocity);
		else
		{
			position.setCartesian(x + halfWidth, y + halfHeight);
			motionVelocity.setCartesian(velocity.x / 60, velocity.y / 60);
		}
	}

	override public function kill():Void
	{
		super.kill();
		setPosition(-10000, -10000);
		isBinded = false;
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

	public inline function fire(pattern:Pattern, bind:Bool):ActorSprite
	{
		var newBullet = army.newBullet();
		this.shotVelocity.calculateAbsolute(newBullet.motionVelocity);
		newBullet.setBlocPattern(pattern);

		if (bind)
		{
			newBullet.position.set(this.shotPosition);
			newBullet.position.setRelativeReference(this.position);
			newBullet.isBinded = true;
		}
		else
			this.shotPosition.calculateAbsolute(newBullet.position);

		return this;
	}

	public inline function setBlocPattern(v:Pattern):Void
	{
		this.adapter.setBlocPattern(v);
	}

	public inline function resetContents():ActorSprite
	{
		position.reset();
		motionVelocity.reset();
		adapter.reset();

		return this;
	}

	private inline function applyAngularVelocities():Void
	{
		if (!bearingAngularVelocity.value.isZero()) position.angle += bearingAngularVelocity.value;

		if (!directionAngularVelocity.value.isZero()) motionVelocity.angle += directionAngularVelocity.value;

		if (!shotBearingAngularVelocity.value.isZero()) shotPosition.angle += shotBearingAngularVelocity.value;

		if (!shotDirectionAngularVelocity.value.isZero()) shotVelocity.angle += shotDirectionAngularVelocity.value;
	}
}

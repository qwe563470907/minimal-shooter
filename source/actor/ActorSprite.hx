package actor;

using tink.core.Ref;
import de.polygonal.ds.Hashable;
import de.polygonal.ds.HashKey;
import flixel.FlxSprite;
import flixel.FlxG;
import bloc.Pattern;
import bloc.AngleInterval;
import actor.behavior.*;

class ActorSprite extends FlxSprite implements Hashable
{
	private static var _temporalVector = new Vector();

	public var key(default, null):Int = HashKey.next();

	public var army:ActorArmy;
	public var adapter:ActorAdapter;

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

	private var _behaviorList:Array<Behavior>;

	private var _isBinded:Bool;
	private var _positionBindingReferenceActor:ActorSprite;

	public function new ()
	{
		super();
		super.kill();

		adapter = new ActorAdapter(this);
		_behaviorList = [];

		position = new Vector();
		motionVelocity = new Vector();
		shotPosition = new Vector();
		shotPosition.setRelativeReference(position);	// relative vector at default
		shotVelocity = new Vector();

		bearingAngularVelocity = AngleInterval.fromZero();
		directionAngularVelocity = AngleInterval.fromZero();
		shotBearingAngularVelocity = AngleInterval.fromZero();
		shotDirectionAngularVelocity = AngleInterval.fromZero();

		resetContents();
	}

	public inline function resetContents():ActorSprite
	{
		position.reset();
		motionVelocity.reset();
		adapter.reset();
		_isBinded = false;
		_positionBindingReferenceActor = this;	// as dummy

		return this;
	}

	/**
	 * Loads graphics.
	 * @param   graphic		The file name.
	 * @param   rotations	Set for calling `loadRotatedGraphic()`.
	 * @return  This `FlxSprite` instance.
	 */
	public inline function setGraphic(graphic:String, ?rotations:Int):flixel.FlxSprite
	{
		if (rotations != null)
			loadRotatedGraphic(graphic, rotations, -1, true, true);
		else
			loadGraphic(graphic);

		return this;
	}

	public inline function addBehavior(Behavior:Behavior)
	{
		_behaviorList.push(Behavior);
	}

	public inline function setBlocPattern(v:Pattern):Void
	{
		this.adapter.setBlocPattern(v);
	}

	override public function update(elapsed:Float):Void
	{
		this.halfWidth = 0.5 * this.width;
		this.halfHeight = 0.5 * this.height;

		for (behavior in _behaviorList)
			behavior.run(this);

		adapter.runBulletHellPattern();
		applyAngularVelocities();

		properFrameCount++;

		syncBlocToFlixel();
		super.update(elapsed);
		syncFlixelToBloc();
	}

	public inline function syncBlocToFlixel():Void
	{
		position.calculateAbsolute(ActorSprite._temporalVector);
		setPosition(ActorSprite._temporalVector.x - halfWidth, ActorSprite._temporalVector.y - halfHeight);
		velocity.set(motionVelocity.x * 60, motionVelocity.y * 60);
	}

	public inline function syncFlixelToBloc():Void
	{
		// Is it really OK????

		if (this._isBinded)
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
		army.receiveDeathNotice(this);
	}

	public inline function fire(pattern:Pattern, bind:Bool):ActorSprite
	{
		var newBullet = army.newBullet();
		this.shotVelocity.calculateAbsolute(newBullet.motionVelocity);
		newBullet.setBlocPattern(pattern);

		if (bind)
		{
			newBullet.bindPosition(this);
			newBullet.position.set(this.shotPosition);
		}
		else
			this.shotPosition.calculateAbsolute(newBullet.position);

		return this;
	}

	public inline function bindPosition(reference:ActorSprite):ActorSprite
	{
		this.position.setRelativeReference(reference.position);
		this._isBinded = true;
		this._positionBindingReferenceActor = reference;

		return this;
	}

	public inline function unbindPosition():ActorSprite
	{
		this.position.absolutize();
		this._isBinded = false;
		this._positionBindingReferenceActor = this;	// as dummy

		return this;
	}

	public inline function receiveDeathNotice(killedActor:ActorSprite):Void
	{
		if (this._isBinded)
		{
			if (this._positionBindingReferenceActor == killedActor)
				unbindPosition();
		}
	}

	public inline function truncateSpeed(max:Float):Void
	{
		motionVelocity.truncate(max);
	}

	/**
	 * Check and see if this object is currently out of the world bounds.
	 *
	 * @param	margin	The margin around the world bounds.
	 * @return   True if the object is out of the world.
	 */
	public inline function isOutOfWorld(margin:Float = 0):Bool
	{
		var vec = ActorSprite._temporalVector;
		position.calculateAbsolute(vec);

		return (
		  (vec.x + halfWidth < FlxG.worldBounds.x - margin) ||
		  (vec.x - halfWidth > FlxG.worldBounds.right + margin) ||
		  (vec.y + halfHeight < FlxG.worldBounds.y - margin) ||
		  (vec.y - halfHeight > FlxG.worldBounds.bottom + margin)
		);
	}

	private inline function applyAngularVelocities():Void
	{
		if (!bearingAngularVelocity.value.isZero()) position.angle += bearingAngularVelocity.value;

		if (!directionAngularVelocity.value.isZero()) motionVelocity.angle += directionAngularVelocity.value;

		if (!shotBearingAngularVelocity.value.isZero()) shotPosition.angle += shotBearingAngularVelocity.value;

		if (!shotDirectionAngularVelocity.value.isZero()) shotVelocity.angle += shotDirectionAngularVelocity.value;
	}
}

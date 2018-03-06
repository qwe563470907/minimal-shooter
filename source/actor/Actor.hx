package actor;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
// import flixel.util.FlxArrayUtil.clearArray;
import flixel.FlxG;
import actor.behavior.*;
import action.*;
import action.element.IElement;

class Actor extends FlxSprite	implements IActor // implements ICleanable
{
	static var standardHighSpeed = 800;

	public var actionStateManager:StateManager;

	public var army:ActorArmy;

	public var currentSpeed:Float = 0;
	public var currentDirectionAngle:Float = 0;
	public var properFrameCount:Int = 0;
	public var centerX(get, never):Float;
	public var centerY(get, never):Float;
	// public var childActors:CleanableGroup<Actor>;

	var behaviorList:Array<IBehavior>;
	public var actionElement:IElement;

	public function new()
	{
		super();
		super.kill();
		behaviorList = [];
		actionStateManager = new StateManager();
		// childActors = new CleanableGroup<Actor>(256);
	}

	// public function clean():Void
	// {
	// 	childActors.clean();
	// }

	public inline function addBehavior(Behavior:IBehavior)
	{
		behaviorList.push(Behavior);
	}

	public inline function setVelocityFromAngle(DirectionAngle:Float, Speed:Float):Void
	{
		velocity.set(Speed);
		velocity.rotate(FlxPoint.weak(0, 0), DirectionAngle);
		currentDirectionAngle = DirectionAngle;
		currentSpeed = Speed;
	}

	public inline function truncateSpeed(max:Float):Void
	{
		if(currentSpeed > max) {
			velocity.set(max * Math.cos(currentDirectionAngle), max * Math.sin(currentDirectionAngle));
		}
	}

	public inline function updateCurrentSpeed():Void
	{
		currentSpeed = velocity.distanceTo(FlxPoint.get(0, 0));
	}

	/**
	 * Check and see if this object is currently out of the world bounds.
	 * 
	 * @param	margin	The margin around the world bounds.
	 * @return   True if the object is out of the world.
	 */
	public inline function isOutOfWorld(margin:Float = 0):Bool
	{
		return (x + width < FlxG.worldBounds.x - margin) || (x > FlxG.worldBounds.right + margin) ||
			(y + height < FlxG.worldBounds.y - margin) || (y > FlxG.worldBounds.bottom + margin);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		for(behavior in behaviorList)
		{
			behavior.run(this);
		}
		if (actionElement != null) actionElement.run(this);
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
		if(Rotations != null)
			loadRotatedGraphic(Graphic, Rotations, -1, true, true);
		else
			loadGraphic(Graphic);

		return this;
	}

	public inline function setCenterPosition(X:Float = 0, Y:Float = 0):Void
	{
		setPosition(X - 0.5 * width, Y - 0.5 * height);
	}

	public inline function fire(?directionAngle:Float = 90, ?speed:Float = 100, ?offsetX:Float = 0, ?offsetY:Float = 0):Actor
	{
		var newBullet = army.newBullet();
		newBullet.setCenterPosition(centerX + offsetX, centerY + offsetY);
		newBullet.setVelocityFromAngle(directionAngle, speed);
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
}

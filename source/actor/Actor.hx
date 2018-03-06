package actor;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
// import flixel.util.FlxArrayUtil.clearArray;
import flixel.FlxG;
import actor.behavior.*;
import action.element.Element;

class Actor extends FlxSprite // implements ICleanable
{
	public var army:ActorArmy;

	public var currentSpeed:Float = 0;
	public var currentDirectionAngle:Float = 0;
	public var properFrameCount:Int = 0;
	public var centerX(get, set):Float;
	public var centerY(get, set):Float;
	// public var childActors:CleanableGroup<Actor>;

	public var actionElement(never, set):Element;

	private var behaviorList:Array<IBehavior>;
	private var adapter:ActorAdapter;

	public function new()
	{
		super();
		super.kill();
		behaviorList = [];
		adapter = new ActorAdapter(this);
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
		adapter.runAction();
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

	public inline function setCenterPosition(x:Float = 0, y:Float = 0):Void
	{
		centerX = x;
		centerY = y;
	}

	public inline function fire(directionAngle:Float, speed:Float, offsetX:Float, offsetY:Float):Actor
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

	function set_centerX(v:Float)
	{
		return x = v - 0.5 * width;
	}

	function set_centerY(v:Float)
	{
		return y = v - 0.5 * height;
	}

	function set_actionElement(v:Element)
	{
		return this.adapter.actionElement = v;
	}
}

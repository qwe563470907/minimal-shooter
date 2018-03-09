package actor;

import action.IActor;
import action.Pattern;
import action.Utility;
import action.StateManager;

// private class TemporalVector implements Vector
// {
// 	public var x: Float;
// 	public var y: Float;

// 	public function new (x: Float, y: Float)
// 	{
// 		this.x = x;
// 		this.y = y;
// 	}
// }

/**
 * Adapter for Actor class and BLOC package.
 */
class ActorAdapter implements IActor
{
	// static private var _temporalVector: Vector = new TemporalVector(0, 0);

	private var _actor: Actor;
	private var _blocPattern: Pattern;
	private var _blocStateManager: StateManager;

	public function new (actor: Actor)
	{
		this._actor = actor;
		this._blocStateManager = new StateManager();
		this._blocPattern = Utility.NULL_PATTERN;
	}

	public function fire(? speed : Float = 200, ? directionAngle : Float = 90): IActor
	{
		this._actor.fire(speed, directionAngle);
		return this;
	}

	public function kill(): Void
	{ this._actor.kill(); }

	public function runBulletHellPattern(): Void
	{ this._blocPattern.run(this); }

	public function getStateManager(): StateManager
	{ return _blocStateManager; }

	// public function getPosition(): Vector
	// {
	// 	_temporalVector.x = this._actor.centerX;
	// 	_temporalVector.y = this._actor.centerY;
	// 	return _temporalVector;
	// }

	public function setPosition(x: Float, y: Float): Void
	{ this._actor.setCenterPosition(x, y); }

	// public function getVelocity(): Vector
	// {
	// 	_temporalVector.x = this._actor.velocity.x;
	// 	_temporalVector.y = this._actor.velocity.y;
	// 	return _temporalVector;
	// }

	public function setVelocity(x: Float, y: Float): Void
	{ this._actor.motionVelocity.setCartesian(x, y); }

	public function addVelocity(x: Float, y: Float): Void
	{ this._actor.motionVelocity.addCartesian(x, y); }

	public function setActionPattern(v: Pattern): Void
	{
		v.prepareState(this._blocStateManager);
		this._blocPattern = v;
	}
}

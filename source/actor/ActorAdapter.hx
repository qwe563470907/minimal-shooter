package actor;

import action.IActor;
import action.element.Element;
import action.element.Utility;
import action.StateManager;

private class TemporalVector implements Vector
{
  public var x:Float;
  public var y:Float;

  public function new(x:Float, y:Float)
  {
    this.x = x;
    this.y = y;
  }
}

class ActorAdapter implements IActor
{
  static private var _temporalVector:Vector = new TemporalVector(0, 0);

  private var _actionElement:Element;

  private var _actor:Actor;
  private var _actionStateManager:StateManager;

  public function new(actor:Actor)
  {
    this._actionStateManager = new StateManager();
    this._actionElement = Utility.NULL_ELEMENT;
    this._actor = actor;
  }

  public function fire(?directionAngle:Float = 90, ?speed:Float = 200, ?offsetX:Float = 0, ?offsetY:Float = 0):IActor
  {
    this._actor.fire(directionAngle, speed, offsetX, offsetY);
    return this;
  }

  public function kill():Void
  { this._actor.kill(); }

  public function runAction():Void
  { this._actionElement.run(this); }

  public function getStateManager():StateManager
  { return _actionStateManager; }

  public function getPosition():Vector
  {
    _temporalVector.x = this._actor.centerX;
    _temporalVector.y = this._actor.centerY;
    return _temporalVector;
  }

  public function setPosition(x:Float, y:Float):Void
  { this._actor.setCenterPosition(x, y); }

  public function getVelocity():Vector
  {
    _temporalVector.x = this._actor.velocity.x;
    _temporalVector.y = this._actor.velocity.y;
    return _temporalVector;
  }

  public function setVelocity(x:Float, y:Float):Void
  { this._actor.velocity.set(x, y); }

  public function addVelocity(x:Float, y:Float):Void
  { this._actor.velocity.add(x, y); }

  public function setActionElement(v:Element):Void
  {
 		v.prepareState(this._actionStateManager);
		this._actionElement = v;
  }
}

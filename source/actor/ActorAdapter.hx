package actor;

import action.IActor;
import action.element.Element;
import action.element.Utility;
import action.StateManager;

class ActorAdapter implements IActor
{
  public var actionStateManager(get, null):StateManager;
  public var actionElement(null, set):Element;
  public var x(get, set):Float;
  public var y(get, set):Float;

  private var _actor:Actor;

  public function new(actor:Actor)
  {
    this.actionStateManager = new StateManager();
    this.actionElement = Utility.NULL_ELEMENT;
    this._actor = actor;
  }

  public function fire(?directionAngle:Float = 90, ?speed:Float = 200, ?offsetX:Float = 0, ?offsetY:Float = 0):IActor
  {
    this._actor.fire(directionAngle, speed, offsetX, offsetY);
    return this;
  }

  public function kill():Void
  {
    this._actor.kill();
  }

  public function runAction():Void
  {
    this.actionElement.run(this);
  }

  function get_actionStateManager()
  {
    return this.actionStateManager;
  }

  function set_actionElement(v:Element)
  {
 		v.prepareState(this.actionStateManager);
		return this.actionElement = v;
  }

  public function get_x()
  {
    return this._actor.centerX;
  }

  public function set_x(v:Float)
  {
    return this._actor.x = v;
  }

  public function get_y()
  {
    return this._actor.centerY;
  }

  public function set_y(v:Float)
  {
    return this._actor.y = v;
  }
}

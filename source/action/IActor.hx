package action;

interface IActor
{
  public var actionStateManager:StateManager;
  public function fire(?directionAngle:Float, ?speed:Float, ?offsetX:Float, ?offsetY:Float):IActor;
  public function kill():Void;
}

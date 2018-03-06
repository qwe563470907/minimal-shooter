package action;

interface IActor
{
  public var actionStateManager(get, null):StateManager;
  public var x(get, set):Float;
  public var y(get, set):Float;
  public function fire(?directionAngle:Float, ?speed:Float, ?offsetX:Float, ?offsetY:Float):IActor;
  public function kill():Void;
}

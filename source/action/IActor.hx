package action;

interface Vector {
  public var x:Float;
  public var y:Float;
};

interface IActor
{
  public function getStateManager():StateManager;
  public function getPosition():Vector;
  public function setPosition(x:Float, y:Float):Void;
  public function getVelocity():Vector;
  public function setVelocity(x:Float, y:Float):Void;
  public function addVelocity(x:Float, y:Float):Void;
  public function fire(?directionAngle:Float, ?speed:Float, ?offsetX:Float, ?offsetY:Float):IActor;
  public function kill():Void;
}

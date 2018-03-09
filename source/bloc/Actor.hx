package bloc;

interface Actor
{
	public function getStateManager():StateManager;
	// public function getPosition():Vector;
	public function setPosition(x:Float, y:Float):Void;
	// public function getVelocity():Vector;
	public function setVelocity(x:Float, y:Float):Void;
	public function addVelocity(x:Float, y:Float):Void;
	public function fire(?speed:Float, ?direction:Float):Actor;
	public function kill():Void;
}

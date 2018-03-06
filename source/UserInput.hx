import flixel.FlxG;

class UserInput {
	public var isMoving:Bool = false;
	public var movingAngle:Float = 0;
  public var isBraking:Bool = false;
  public var isShooting:Bool = false;

  public function new() {
  }

	public function update() {
		var _up:Bool = FlxG.keys.anyPressed([UP, W]);
		var _down:Bool = FlxG.keys.anyPressed([DOWN, S]);
		var _left:Bool = FlxG.keys.anyPressed([LEFT, A]);
		var _right:Bool = FlxG.keys.anyPressed([RIGHT, D]);
    isBraking = FlxG.keys.anyPressed([SHIFT]);
    isShooting = FlxG.keys.anyPressed([Z, SPACE]);

		if(_up && _down)
			_up = _down = false;

		if(_left && _right)
			_left = _right = false;

		if(_up || _down || _left || _right)
		{
			isMoving = true;

			if(_up)
			{
				movingAngle = -90;

				if(_left)
					movingAngle -= 45;
				else if(_right)
					movingAngle += 45;
			}
			else if(_down)
			{
				movingAngle = 90;

				if(_left)
					movingAngle += 45;
				else if(_right)
					movingAngle -= 45;
			}
			else if(_left)
				movingAngle = 180;
			else if(_right)
				movingAngle = 0;
		} else
			isMoving = false;
	}
}
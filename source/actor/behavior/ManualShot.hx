package actor.behavior;

import bloc.Command;

class ManualShot implements Behavior
{
	var _userInput:UserInput;
	var _fireCommand:Command;

	public function new (Input:UserInput)
	{
		_userInput = Input;
		_fireCommand = new Command("fire");
	}

	public function run(actor:ActorSprite):Void
	{
		if (!_userInput.isShooting)
			return;

		actor.adapter.receiveCommand(_fireCommand);
	}
}

package actor.behavior;

class ListenInput implements Behavior
{
	var userInput: UserInput;

	public function new (Input: UserInput)
	{
		userInput = Input;
	}

	public function run(actor: ActorSprite): Void
	{
		userInput.update();
	}
}

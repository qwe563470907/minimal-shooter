package actor.behavior;

class ListenInput implements IBehavior
{
	var userInput:UserInput;

  public function new(Input:UserInput)
  {
    userInput = Input;
  }

  public function run(actor:Actor):Void
  {
    userInput.update();
  }
}

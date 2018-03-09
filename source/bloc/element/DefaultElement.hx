package bloc.element;

class DefaultElement implements Element
{
	private function new () {}

	public function run(actor: Actor): Bool
	{
		return true;
	}

	public function prepareState(manager: StateManager): Void
	{
	}

	public function resetState(actor: Actor): Void
	{
	}

	public function toString(): String
	{
		return "";
	}
}

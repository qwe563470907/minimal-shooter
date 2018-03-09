package bloc.element;

class DefaultElement implements Element
{
	private function new () {}

	public function run(actor: IActor): Bool
	{
		return true;
	}

	public function prepareState(manager: StateManager): Void
	{
	}

	public function resetState(actor: IActor): Void
	{
	}

	public function toString(): String
	{
		return "";
	}
}

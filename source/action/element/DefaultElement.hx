package action.element;

class DefaultElement implements IElement {
	private function new() {}
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
}

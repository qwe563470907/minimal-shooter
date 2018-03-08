package action.element;

interface Element
{
	public function run(actor: IActor): Bool;
	public function prepareState(manager: StateManager): Void;
	public function resetState(actor: IActor): Void;
	public function toString(): String;
}

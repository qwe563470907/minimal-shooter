package action.element;

interface IElement
{
	public function run(actor: IActor): Bool;
	public function prepareState(manager: StateManager): Void;
	public function resetState(actor: IActor): Void;
}

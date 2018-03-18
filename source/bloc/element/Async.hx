package bloc.element;

class Async extends WrapperElement
{
	public function new (pattern:Pattern)
	{
		super(async_element, pattern);
	}

	override public inline function run(actor:Actor):Bool
	{
		this.resetChildState(actor);
		actor.addSubThreadPattern(this._pattern);

		return true;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		super.prepareState(manager);
	}
}

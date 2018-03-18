package bloc.element;

class Endless extends WrapperElement
{
	public function new (pattern:Pattern)
	{
		super(endless_element, pattern);
	}

	override public inline function run(actor:Actor):Bool
	{
		while (this._pattern.run(actor))
			this.resetChildState(actor);

		return false;
	}
}

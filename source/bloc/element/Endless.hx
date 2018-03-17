package bloc.element;

import bloc.element.ElementUtility.indent;

class Endless extends Sequence
{
	override public inline function run(actor:Actor):Bool
	{
		while (super.run(actor))
			this.resetState(actor);

		return false;
	}

	override public function toString():String
	{
		return "endless:\n" + indent(this.render());
	}
}

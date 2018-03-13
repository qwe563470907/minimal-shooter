package bloc.element;

/**
 * Null object class for Element.
 * Used only if the parser failed to parse the BLOC file and cannot create the proper BLOC element instance.
 */
class NullElement extends DefaultElement
{
	public function new ()
	{
		super();
	}

	override public inline function run(actor:Actor):Bool
	{
		return true;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
	}

	override public inline function resetState(actor:Actor):Void
	{
	}

	override public function toString():String
	{
		return "null element";
	}
}

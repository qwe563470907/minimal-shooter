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

	override public function toString():String
	{
		return "null element";
	}
}

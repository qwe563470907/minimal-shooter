package bloc.element;

class NullElement extends DefaultElement
{
	public function new ()
	{
		super();
	}

	override public function toString(): String
	{
		return "null";
	}
}

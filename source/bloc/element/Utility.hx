package bloc.element;

class Utility
{
	static public function indent(str:String):String
	{
		return "  " + StringTools.replace(str, "\n", "\n  ");
	}
}

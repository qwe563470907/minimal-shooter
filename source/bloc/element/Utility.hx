package bloc.element;

class Utility
{
	static public function indent(str:String):String
	{
		return "  " + StringTools.replace(str, "\n", "\n  ");
	}
}

enum Operation
{
	SET;
	ADD;
	SUBTRACT;
}

enum Coordinates
{
	CARTESIAN;
	POLAR;
}

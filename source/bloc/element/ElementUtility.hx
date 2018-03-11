package bloc.element;

class ElementUtility
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

enum ElementName
{
	POSITION;
	VELOCITY;
	SHOT_VELOCITY;
	FIRE;
	WAIT;
	SEQUENCE;
	PARALLEL;
	REPEAT;
	ENDLESS;
	IF;
	NULL;
}

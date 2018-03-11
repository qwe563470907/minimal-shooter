package bloc.element;

class Utility
{
	static public function indent(str:String):String
	{
		return "  " + StringTools.replace(str, "\n", "\n  ");
	}

	static public function stringToOperation(op: String):Operation
	{

		return switch (op)
		{
			case "set": SET;

			case "add": ADD;

			case "subtract": SUBTRACT;

			default: throw "Invalid operation type: " + op;
		}
	}

	static public function operationToString(op: Operation):String
	{

		return switch (op)
		{
			case SET: "set";

			case ADD: "add";

			case SUBTRACT: "sub";
		}
	}

	static public function stringToCoords(coords: String):Coordinates
	{

		return switch (coords)
		{
			case "cartesian": CARTESIAN;

			case "polar": POLAR;

			default: throw "Invalid coordinates: " + coords;
		}
	}

	static public function coordsToString(op: Coordinates):String
	{

		return switch (op)
		{
			case CARTESIAN: "cartesian";

			case POLAR: "polar";
		}
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

package bloc.element;

import bloc.element.ElementUtility;
import bloc.element.ElementUtility.*;

class WrapperElement extends DefaultElement
{
	private var _elementName:ElementName;
	private var _pattern:Pattern;

	public function new (elementName: ElementName, pattern:Pattern)
	{
		super();
		this._elementName = elementName;
		this._pattern = pattern;
	}

	override public function prepareState(manager:StateManager):Void
	{
		super.prepareState(manager);
		this._pattern.prepareState(manager);
	}

	override public inline function containsWait():Bool
	{
		return this._pattern.containsWait();
	}

	override public function toString():String
	{
		return enumToString(this._elementName) + ":\n" + indent(this._pattern.toString());
	}

	private inline function resetChildState(actor:Actor):Void
	{
		this._pattern.resetState(actor);
	}
}

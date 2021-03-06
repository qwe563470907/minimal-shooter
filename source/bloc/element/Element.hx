package bloc.element;

import de.polygonal.ds.Hashable;

interface Element extends Hashable
{
	public function run(actor:Actor):Bool;
	public function prepareState(manager:StateManager):Void;
	public function resetState(actor:Actor):Void;
	public function toString():String;
	public function containsWait():Bool;
}

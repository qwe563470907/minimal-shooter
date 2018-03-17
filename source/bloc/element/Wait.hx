package bloc.element;

class Wait extends DefaultElement
{
	public var waitCount:Int;

	public function new (?count:Int = 1)
	{
		super();
		this.waitCount = count;
	}

	override public inline function run(actor:Actor):Bool
	{
		var state = actor.getStateManager().getCountState(this);
		state.increment();

		return state.isCompleted;
	}

	override public inline function prepareState(manager:StateManager):Void
	{
		manager.addCountState(this, this.waitCount + 1);
	}

	override public inline function resetState(actor:Actor):Void
	{
		actor.getStateManager().getCountState(this).reset();
	}

	override public function toString():String
	{
		return "wait " + this.waitCount;
	}

	override public inline function containsWait():Bool
	{
		return true;
	}
}

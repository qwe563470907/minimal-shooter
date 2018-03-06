package actor.behavior;

class DieOutOfWorld implements IBehavior
{
  var margin:Float;

  public function new(Margin:Float)
  {
    margin = Margin;
  }

  public function run(actor:Actor):Void
  {
    if (actor.isOutOfWorld(margin))
      actor.kill();
  }
}

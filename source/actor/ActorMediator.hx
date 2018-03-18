package actor;

import de.polygonal.ds.HashTable;
import de.polygonal.ds.ArrayList;

typedef ActorList = ArrayList<ActorSprite>;

class ActorMediator
{
	/**
	 * The reference map for alive monitoring between actors.
	 *   Key: The reference actor.
	 *   Value: The list of actors which refer the key actor.
	 * If the reference actor has been killed, each referer has to remove its own reference to that actor.
	 */
	private var _actorReferersMap(null, never) = new HashTable<ActorSprite, ActorList>(1024, 1024);

	public function new ()
	{
	}

	public inline function reset():Void
	{
		this._actorReferersMap.clear();
	}

	public inline function registerActor(actor:ActorSprite):Void
	{
		var referers = new ActorList(64);
		referers.reuseIterator = true;
		this._actorReferersMap.setIfAbsent(actor, referers);
	}

	public inline function addActorReference(referer:ActorSprite, reference:ActorSprite):Void
	{
		this.getReferers(reference).add(referer);
	}

	public inline function receiveDeathNotice(reference:ActorSprite):Void
	{
		var referers = this.getReferers(reference);

		for (referer in referers)
		{
			// referer.receiveDeathNotice(reference);
		}

		referers.clear();
	}

	private inline function getReferers(reference:ActorSprite):ActorList
	{
		return this._actorReferersMap.get(reference);
	}
}

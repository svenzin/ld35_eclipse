package eclipse.level;
import eclipse.Eclipse.BaseLevel;
import eclipse.Level;
import eclipse.fx.Explosion;
import eclipse.fx.Lover;
import eclipse.fx.Spark;
import flash.geom.Point;
import lde.Lde;

/**
 * ...
 * @author scorder
 */
class Level1 extends Root
{

	public function new() 
	{
		super();
		next = new Level2();
	}
	
	var planet : Planet;
	override public function init():Void 
	{
		planet = Planet.make(1);
		planet.moveTo(250, 100);
		
		Tween.wait(15).then(function ()
		{
			Spark.at(new Point(50, 100), function (p)
			{
				var s = new Ship();
				s.moveTo(50, 100);
				s.absorb(p);
				Controller.acquire(s);
				
				entities.add(p);
				entities.add(s);
			});
		});
	}
	
	public function victory()
	{
		Tween.wait(150).then(function ()
		{
			entities.clear();
			Eclipse.get().collider.objects.clear();
			Eclipse.get().steppers.clear();
			Lde.objects.clear();
			state = BaseLevel.VICTORY;
		});
	}
	
	override public function step():Void 
	{
		super.step();
		
		var hits = Eclipse.instance.collider.check(planet.phx[0]);
		for (hit in hits)
		{
			if (hit.shape.parent.type == EntityType.SHIP)
			{
				var ship = cast(hit.shape.parent, Ship);
				var part = ship.eject();
				planet.absorb(part);
				Controller.release();
				entities.remove(ship);
				
				Explosion.at(hit.point);
			}
		}
		
		if (planet.state == Planet.PEACEFUL)
		{
			victory();
		}
	}
}
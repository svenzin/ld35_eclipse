package eclipse.level;
import eclipse.Eclipse.BaseLevel;
import eclipse.Level;
import eclipse.fx.Spark;
import flash.geom.Point;
import lde.Lde;

/**
 * ...
 * @author scorder
 */
class Level1 extends BaseLevel
{

	public function new() 
	{
	}
	
	public var entities = new List<MyEntity>();

	var planet : Planet;
	override public function init():Void 
	{
		planet = Planet.make(1);
		planet.moveTo(250, 100);
		
		Tween.wait(60).then(function ()
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
	
	override public function step():Void 
	{
		Controller.apply();
		
		for (e in entities)
		{
			e.vx = 0.9 * e.vx + e.ax;
			e.vy = 0.9 * e.vy + e.ay;
			e.moveBy(e.vx, e.vy);
		}

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
			}
		}
		
		if (planet.state == Planet.PEACEFUL)
		{
			entities.clear();
			Eclipse.get().collider.objects.clear();
			Eclipse.get().steppers.clear();
			Lde.objects.clear();
			
			state = BaseLevel.VICTORY;
		}
	}
}
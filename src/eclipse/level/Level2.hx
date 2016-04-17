package eclipse.level;
import eclipse.Eclipse;
import eclipse.Level;
import eclipse.Level;
import eclipse.col.Col.Hit;
import eclipse.fx.Explosion;
import eclipse.fx.Spark;
import lde.Lde;
import openfl.geom.Point;

/**
 * ...
 * @author scorder
 */
class Level2 extends Root
{

	public function new() 
	{
		super();
	}
	
	override public function init():Void 
	{
		var planet = Planet.make(1);
		planet.moveTo(250, 50);
		entities.add(planet);
		
		planet = Planet.make(1);
		planet.moveTo(50, 150);
		entities.add(planet);
		
		var part = Part.make_core();
		part.moveTo(150, 100);
		entities.add(part);
		
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
	
	function ship_part(ship : Ship, part : Part, hit : Hit)
	{
		ship.absorb(part);
	}
	function ship_planet(ship : Ship, planet : Planet, hit : Hit)
	{
		if (planet.can_absorb())
		{
			var part = ship.eject();
			planet.absorb(part);
		}
		var vector = new Point(ship.x, ship.y).subtract(new Point(planet.x, planet.y));
		vector.normalize(5);
		ship.vx = vector.x; ship.vy = vector.y;
		if (ship.parts.length == 0)
		{
			Controller.release();
			ship.destroy();
		}
		Explosion.at(hit.point);
	}
	override public function step():Void 
	{
		super.step();
		
		var hits = Eclipse.instance.collider.check_all();
		for (hit in hits)
		{
			if (hit.source.parent.type == EntityType.SHIP) {
				if (hit.shape.parent.type == EntityType.SHIP) {
					
				} else if (hit.shape.parent.type == EntityType.PART) {
					ship_part(cast(hit.source.parent, Ship),
					          cast(hit.shape.parent, Part),
							  hit);
				} else if (hit.shape.parent.type == EntityType.PLANET) {
					ship_planet(cast(hit.source.parent, Ship),
					            cast(hit.shape.parent, Planet),
							    hit);
				}
			} else if (hit.source.parent.type == EntityType.PART) {
				if (hit.shape.parent.type == EntityType.SHIP) {
					ship_part(cast(hit.shape.parent, Ship),
					          cast(hit.source.parent, Part),
							  hit);
				} else if (hit.shape.parent.type == EntityType.PART) {
					
				} else if (hit.shape.parent.type == EntityType.PLANET) {
					
				}
			} else if (hit.source.parent.type == EntityType.PLANET) {
				if (hit.shape.parent.type == EntityType.SHIP) {
					ship_planet(cast(hit.shape.parent, Ship),
					            cast(hit.source.parent, Planet),
							    hit);
				} else if (hit.shape.parent.type == EntityType.PART) {
					
				} else if (hit.shape.parent.type == EntityType.PLANET) {
					
				}
			}
		}
		
		var total = 0;
		var victories = 0;
		var defeats = 0;
		for (e in entities)
		{
			if (e.type == EntityType.PLANET)
			{
				var p = cast(e, Planet);
				if (p.state == Planet.PEACEFUL) ++victories;
				if (p.state == Planet.DESTROYED) ++defeats;
				++total;
			}
		}
		if (victories + defeats == total)
		{
			if (victories >= 1) victory();
		}
	}
}
package eclipse;
import eclipse.Level.Ship;
import eclipse.fx.Lover;
import eclipse.gfx.PartGfx;
import eclipse.Level.Planet;
import eclipse.col.Col;
import eclipse.col.Disk;
import eclipse.fx.Explosion;
import eclipse.fx.Thrust;
import eclipse.gfx.PartsGfx;
import eclipse.gfx.PlanetsGfx;
import eclipse.particle.Attractor;
import eclipse.particle.Emitter;
import lde.Key;
import lde.Lde;
import lde.gfx.Animation;
import lde.gfx.AnimationPlayback;
import openfl.display.Bitmap;
import openfl.geom.Point;
import openfl.ui.Keyboard;
import eclipse.Eclipse;
import eclipse.fx.Spark;

/**
 * ...
 * @author scorder
 */
class A
{
	static public function play(_anim : Animation)
	{
		return new AnimationPlayback(_anim).play();
	}
}

enum EntityType
{
	UNKNOWN;
	PLANET;
	SHIP;
	PART;
}

class MyEntity extends Entity
{
	public var type : EntityType = EntityType.UNKNOWN;
	
	public var phx = new Array<Disk>();
	public var phx_centers = new Array<Point>();
	
	public var gfx = new Array<AnimationPlayback>();
	public var gfx_centers = new Array<Point>();
	
	public var vx : Float;
	public var vy : Float;
	public var ax : Float;
	public var ay : Float;
	
	public function new()
	{
		super();
		x = 0; y = 0;
		vx = 0; vy = 0;
		ax = 0; ay = 0;
	}
	
	override public function render(surface:Bitmap) 
	{
		if (is_visible)
		{
			super.render(surface);
			for (i in 0...gfx.length)
			{
				gfx[i].renderAt(new Point(x, y).add(gfx_centers[i]), surface);
			}
		}
	}
	
	public function moveTo(_x : Float, _y : Float)
	{
		x = _x;
		y = _y;
		for (i in 0...phx.length)
		{
			phx[i].x = x + phx_centers[i].x;
			phx[i].y = y + phx_centers[i].y;
		}
	}
	public function moveBy(_x : Float, _y : Float) { return moveTo(x + _x, y + _y); }
}

class Part extends MyEntity
{
	public var part_type : PartsType = PartsType.UNKNOWN;
	public function new()
	{
		super();
		type = EntityType.PART;
	}
	static public function make_empty()
	{
		var p = new Part();
		p.part_type = PartsType.EMPTY;
		p.gfx.push(A.play(PartsGfx.PART));
		p.gfx_centers.push(new Point());
		//p.gfx.push(A.play(PartsGfx.KOA));
		//p.gfx_centers.push(new Point());
		var d = new Disk(0, 0, 4, p);
		p.phx.push(d);
		p.phx_centers.push(new Point(PartsGfx.size / 2, PartsGfx.size / 2));
		Eclipse.get().collider.objects.add(d);
		
		Lde.add(p);
		p.is_visible = true;
		return p;
	}
	static public function make_core()
	{
		var p = new Part();
		p.part_type = PartsType.CORE;
		p.gfx.push(A.play(PartsGfx.PART));
		p.gfx_centers.push(new Point());
		p.gfx.push(A.play(PartsGfx.KOA));
		p.gfx_centers.push(new Point());
		var d = new Disk(0, 0, 4, p);
		p.phx.push(d);
		p.phx_centers.push(new Point(PartsGfx.size / 2, PartsGfx.size / 2));
		Eclipse.get().collider.objects.add(d);
		
		Lde.add(p);
		p.is_visible = true;
		return p;
	}
}

class Ship extends MyEntity implements IStepper
{
	public function new()
	{
		super();
		type = EntityType.SHIP;
		Eclipse.get().steppers.add(this);
	}
	
	static public var max_parts = 5;
	static public var parts_center = [
		new Point(0, 0),
		new Point(PartsGfx.size, 0),
		new Point(0, PartsGfx.size),
		new Point(-PartsGfx.size, 0),
		new Point(0, -PartsGfx.size),
	];
	
	public var parts = new Array<Part>();
	public var thrusters = new Array<Thrust>();
	
	public function can_absorb(_part : Part) : Bool
	{
		if (parts.length == 0) return _part.part_type == PartsType.CORE;
		return parts.length < max_parts;
	}
	
	public function absorb(_part : Part)
	{
		if (can_absorb(_part))
		{
			for (p in _part.phx)
			{
				p.parent = this;
			}
			parts.push(_part);
			moveTo(x, y);
			
			if (_part.part_type == PartsType.CORE)
			{
				var t = new Thrust();
				Lde.add(t);
				thrusters.push(t);
			}
			else
			{
				thrusters.push(null);
			}
		}
	}
	
	public function eject()
	{
		var part = parts.pop();
		for (p in part.phx)
		{
			p.parent = part;
		}
		var t = thrusters.pop();
		if (t != null) Lde.remove(t);
		return part;
	}
	
	public function get_thrust()
	{
		return 0.2;
	}
	
	public function destroy()
	{
		Eclipse.get().steppers.remove(this);
	}
	
	override public function moveTo(_x:Float, _y:Float) 
	{
		super.moveTo(_x, _y);
		for (i in 0...parts.length)
		{
			parts[i].moveTo(_x + parts_center[i].x, _y + parts_center[i].y);
		}
	}
	
	public function step()
	{
		for (i in 0...parts.length)
		{
			var t = thrusters[i];
			if (t != null)
			{
				t.at(parts[i].x + PartsGfx.size / 2,
				                parts[i].y + PartsGfx.size / 2);
				t.towards( -ax, -ay);
				t.step();
			}
		}
	}
}

class Planet extends MyEntity
{
	static public var slots_centers = [
		[],
		[ new Point( -PartsGfx.size / 2, -PartsGfx.size / 2) ],
		[ new Point( -PartsGfx.size, -PartsGfx.size / 2),
		  new Point( 0, -PartsGfx.size / 2) ],
		[ new Point( -PartsGfx.size, -PartsGfx.size),
		  new Point( 0, -PartsGfx.size),
		  new Point( -PartsGfx.size / 2, 0) ],
		[ new Point( -PartsGfx.size, -PartsGfx.size),
		  new Point( 0, -PartsGfx.size),
		  new Point( -PartsGfx.size, 0),
		  new Point( 0, 0) ]
	];
	
	public var max_parts : Int;
	public var parts = new Array<Part>();
	
	public function new()
	{
		super();
		type = EntityType.PLANET;
	}
	
	static public function make(_slots : Int)
	{
		var center = new Point(PlanetsGfx.radius[_slots], PlanetsGfx.radius[_slots]);
		
		var p = new Planet();
		p.max_parts = _slots;
		p.gfx.push(A.play(PlanetsGfx.get(_slots)));
		p.gfx_centers.push(new Point());
		for (i in 0..._slots)
		{
			p.gfx.push(A.play(PartsGfx.EMPTY));
			p.gfx_centers.push(center.add(slots_centers[_slots][i]));
		}
		var d = new Disk(0, 0, PlanetsGfx.radius[_slots], p);
		p.phx.push(d);
		p.phx_centers.push(center);
		Eclipse.get().collider.objects.add(d);
		
		p.is_visible = true;
		Lde.add(p);
		return p;
	}

	public function can_absorb() : Bool
	{
		return parts.length < max_parts;
	}
	
	public function absorb(_part : Part)
	{
		if (can_absorb())
		{
			for (p in _part.phx)
			{
				p.parent = this;
			}
			parts.push(_part);
			moveTo(x, y);
			
			if (parts.length >= max_parts)
			{
				bloom();
			}
		}
	}
	
	public static var GROWING = 1;
	public static var PEACEFUL = 2;
	public static var DESTROYED = 3;
	public var state = GROWING;
	public function bloom()
	{
		new Lover().position.setTo(
			x + PlanetsGfx.radius[max_parts],
			y + PlanetsGfx.radius[max_parts]);
		state = PEACEFUL;
	}
	public function destroy()
	{
		state = DESTROYED;
	}

	override public function moveTo(_x:Float, _y:Float) 
	{
		super.moveTo(_x, _y);
		for (i in 0...parts.length)
		{
			parts[i].moveTo(_x + PlanetsGfx.radius[max_parts] + slots_centers[max_parts][i].x,
			                _y + PlanetsGfx.radius[max_parts] + slots_centers[max_parts][i].y);
		}
	}
}

class Controller
{
	static public var target : Ship;
	static public function acquire(_ship : Ship)
	{
		target = _ship;
	}
	static public function release()
	{
		target = null;
	}
	static public function apply()
	{
		var a = new Point();
		if (Key.isDown(Keyboard.LEFT)) a.x -= 1;
		if (Key.isDown(Keyboard.RIGHT)) a.x += 1;
		if (Key.isDown(Keyboard.UP)) a.y -= 1;
		if (Key.isDown(Keyboard.DOWN)) a.y += 1;
		
		if (target != null)
		{
			a.normalize(target.get_thrust());
			target.ax = a.x;
			target.ay = a.y;
		}
	}
}
class Level extends BaseLevel
{
	public function new() {}

	public var entities = new List<MyEntity>();
	public function add(_e : MyEntity)
	{
		entities.add(_e);
	}
	public function remove(_e : MyEntity)
	{
		entities.remove(_e);
	}
	
	var planet : Planet;
	var part : Part;
	var koa : Part;
	var ship : Ship;
	override public function init()
	{
		planet = Planet.make(3);
		planet.moveTo(30, 30);
		add(planet);
		
		part = Part.make_empty();
		part.moveTo(120, 100);
		add(part);
		
		koa = Part.make_core();
		koa.moveTo(100, 100);
		add(koa);
		
		ship = new Ship();
		ship.moveTo(150, 150);
		ship.absorb(koa);
		add(ship);
		
		Controller.acquire(ship);
	}

	override public function step()
	{
		if (Key.isPushed(Keyboard.NUMBER_1)) Lde.visible = !Lde.visible;
		if (Key.isPushed(Keyboard.NUMBER_2)) Eclipse.instance.collider.visible = !Eclipse.instance.collider.visible;
		
		if (Key.isPushed(Keyboard.TAB))
		{
			//Spark.at(new Point(150, 150), make_ship);
		}
		
		Controller.apply();
		
		for (e in entities)
		{
			e.vx = 0.9 * e.vx + e.ax;
			e.vy = 0.9 * e.vy + e.ay;
			e.moveBy(e.vx, e.vy);
		}
		
		var hits = Eclipse.instance.collider.check_all();
		for (hit in hits)
		{
			if (hit.source.parent.type == EntityType.SHIP)
			{
				var ship = cast(hit.source.parent, Ship);
				if (hit.shape.parent.type == EntityType.PART)
				{
					var part = cast(hit.shape.parent, Part);
					ship.absorb(part);
				}
				else if (hit.shape.parent.type == EntityType.PLANET)
				{
					var planet = cast(hit.shape.parent, Planet);
					var part = ship.eject();
					planet.absorb(part);
					var repulsion = new Point().subtract(hit.depth);
					repulsion.normalize(5);
					ship.vx = repulsion.x; ship.vy = repulsion.y;
				}
			}
			else if (hit.source.parent.type == EntityType.PART)
			{
				var part = cast(hit.source.parent, Part);
				if (hit.shape.parent.type == EntityType.SHIP)
				{
					var ship = cast(hit.shape.parent, Ship);
					ship.absorb(part);
				}
				else if (hit.shape.parent.type == EntityType.PLANET)
				{
					var planet = cast(hit.shape.parent, Planet);
				}
			}
		}
	}
}
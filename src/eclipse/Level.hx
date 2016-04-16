package eclipse;
import eclipse.Level.PhxEntity;
import eclipse.Level.Planet;
import eclipse.col.Col;
import eclipse.col.Disk;
import eclipse.particle.Attractor;
import eclipse.particle.Emitter;
import lde.Key;
import lde.Lde;
import lde.gfx.Animation;
import openfl.geom.Point;
import openfl.ui.Keyboard;
import eclipse.Eclipse;

/**
 * ...
 * @author scorder
 */
enum EntityType
{
	UNKNOWN;
	PLANET;
	SHIP;
}
class PhxEntity extends Entity
{
	public var type : EntityType;
	public var center : Point;
	public var phx : Disk;
	public function new(_r : Float, _type : EntityType)
	{
		super();
		type = _type;
		phx = new Disk(0, 0, _r);
		phx.parent = this;
		center = new Point(_r, _r);
		moveTo(x, y);
	}
	
	public function moveToPoint(p : Point) { moveTo(p.x, p.y); }
	public function moveTo(x : Float, y : Float)
	{
		this.x = x;
		this.y = y;
		phx.x = this.x + center.x;
		phx.y = this.y + center.y;
	}
	
	public function moveByVector(d : Point) { moveBy(d.x, d.y); }
	public function moveBy(dx : Float, dy : Float)
	{
		this.x += dx;
		this.y += dy;
		phx.x = this.x + center.x;
		phx.y = this.y + center.x;
	}
}

class Core extends PhxEntity
{
	public function new()
	{
		super(4, SHIP);
		
		play(Parts.CORE);
		
		vx = 0;
		vy = 0;
	}
	
	public var vx : Float;
	public var vy : Float;
}

class Planet extends PhxEntity
{
	public static function make(_slots : Int, _parts : Array<PartsType>)
	{
		var r = 20;
		var planet = new Planet(r);
		while (_slots > 0)
		{
			planet.types.push(PartsType.EMPTY);
			--_slots;
		}
		for (type in _parts)
		{
			planet.absorb(type);
		}
		return planet;
	}
	
	public var types = new Array<PartsType>();
	public function new(_r : Int)
	{
		super(_r, PLANET);
		
		var a = new Animation([ Art.disk(_r, Color.GREEN) ]);
		play(a);
	}
	public function absorb(_part : PartsType)
	{
		types.shift();
		types.push(_part);
		if (types[0] != PartsType.EMPTY)
		{
			bloom();
		}
	}
	public function bloom()
	{
		
	}
}
class Spark
{
	public var attractor = new Attractor();
	public function new()
	{
		
	}
}
class Level
{

	public function new() 
	{
		
	}

	var col = new Col();

	var spark : Spark;
	var attractor = new Attractor();
	var emitter = new Emitter();
	var koa = new Core();
	var planet : Planet;
	public function init()
	{
		planet = Planet.make(1, []);
		Lde.add(planet);
		col.objects.add(planet.phx);
		planet.moveTo(50, 50);
		
		Lde.add(koa);
		col.objects.add(koa.phx);
		koa.moveTo(20, 20);
		target = koa;
		
		emitter.data = Art.rect(2, 2, Color.GREY_25);
		emitter.dampen = 0.01;
		emitter.lifetime = 60;
		emitter.position = new Point(koa.x, koa.y);
		emitter.strength = 0.2;
		emitter.vitality = 0.5;
		//emitter.direction = Point.polar(0.5, 0);
		Lde.add(emitter);
		Eclipse.instance.steppers.add(emitter);
		
		attractor.data = Art.rect(2, 2, Color.PURPLE);
		attractor.lifetime = 120;
		attractor.position = emitter.position;
		attractor.radius = 30;
		attractor.strength = 10;
		attractor.vitality = 0.2;
		Lde.add(attractor);
		Eclipse.instance.steppers.add(attractor);
		
		Lde.add(col);
	}

	var target : Core = null;
	public function step()
	{
		var a = new Point();
		if (Key.isDown(Keyboard.LEFT)) a.x -= 1;
		if (Key.isDown(Keyboard.RIGHT)) a.x += 1;
		if (Key.isDown(Keyboard.UP)) a.y -= 1;
		if (Key.isDown(Keyboard.DOWN)) a.y += 1;
		
		if (Key.isPushed(Keyboard.SPACE)) attractor.is_active = !attractor.is_active;
		
		if (Key.isPushed(Keyboard.NUMBER_1)) Lde.visible = !Lde.visible;
		if (Key.isPushed(Keyboard.NUMBER_2)) col.visible = !col.visible;
		
		if (Key.isPushed(Keyboard.ESCAPE)) target = null;
		
		a.normalize(0.2);
		
		if (target != null)
		{
			target.vx = 0.9 * target.vx + a.x;
			target.vy = 0.9 * target.vy + a.y;
			
			target.moveBy(target.vx, target.vy);
			
			var hit = col.check_one(target.phx, planet.phx);
			if (hit != null)
			{
				var d = hit.depth;
				target.moveBy(-d.x, -d.y);
			}
			emitter.position.x = target.x + Parts.size / 2;
			emitter.position.y = target.y + Parts.size / 2;
			emitter.direction.x = -a.x;
			emitter.direction.y = -a.y;
			emitter.direction.normalize(0.5);
		}
		emitter.is_active = (a.length != 0) && (target != null);
	}
}
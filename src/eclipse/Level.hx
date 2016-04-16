package eclipse;
import eclipse.Level.PhxEntity;
import eclipse.Level.Planet;
import eclipse.col.Col;
import eclipse.col.Disk;
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

class Level
{

	public function new() 
	{
		
	}

	var col = new Col();
	
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
		
		Lde.add(col);
	}
	
	public function step()
	{
		var ax : Float = 0;
		var ay : Float = 0;
		if (Key.isDown(Keyboard.LEFT)) ax -= 1;
		if (Key.isDown(Keyboard.RIGHT)) ax += 1;
		if (Key.isDown(Keyboard.UP)) ay -= 1;
		if (Key.isDown(Keyboard.DOWN)) ay += 1;
		
		if (Key.isPushed(Keyboard.NUMBER_1)) col.visible = !col.visible;
		
		ax = 0.2 * ax;
		ay = 0.2 * ay;
		
		koa.vx = 0.9 * koa.vx + ax;
		koa.vy = 0.9 * koa.vy + ay;
		
		koa.moveBy(koa.vx, koa.vy);
		
		var hit = col.check_one(koa.phx, planet.phx);
		if (hit != null)
		{
			var d = hit.depth;
			koa.moveBy(-d.x, -d.y);
		}
	}
}
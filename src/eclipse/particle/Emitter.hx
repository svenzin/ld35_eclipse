package eclipse.particle;
import eclipse.Eclipse.IStepper;
import lde.Lde.Entity;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;

/**
 * ...
 * @author scorder
 */
class Emitter extends Entity implements IStepper
{
	public var data : BitmapData;
	
	public var n = 0;
	public var p = new Array<Point>();
	public var t = new Array<Int>();
	public var v = new Array<Point>();
	
	public var position = new Point();
	public var vitality = 0.0;
	public var strength = 0.0;
	public var direction = new Point();
	public var lifetime : Int = 0;
	public var dampen = 0.0;
	
	public var is_active = false;
	public function new() 
	{
		super();
	}
	
	var total_vitality = 0.0;
	public function step()
	{
		// Generate
		if (is_active)
		{
			total_vitality += vitality;
			var count = Std.int(total_vitality);
			for (i in 0...count)
			{
				if (n == p.length)
				{
					p.push(new Point());
					v.push(new Point());
					t.push(0);
				}
				
				p[n].x = position.x;
				p[n].y = position.y;
				var z = 2 * Math.PI * Std.random(360) / 360;
				v[n] = Point.polar(strength, z).add(direction);
				t[n] = lifetime;
				++n;
			}
			total_vitality -= count;
		}
		// Move
		for (i in 0...n)
		{
			t[i] -= 1;
			v[i].x *= (1 - dampen);
			v[i].y *= (1 - dampen);
			p[i].x += v[i].x;
			p[i].y += v[i].y;
		}
		// Clean
		var i = n - 1;
		while (i >= 0)
		{
			if (t[i] <= 0)
			{
				--n;
				t[i] = t[n];
				p[i].x = p[n].x;
				p[i].y = p[n].y;
				v[i].x = v[n].x;
				v[i].y = v[n].y;
			}
			--i;
		}
	}
	
	override public function render(surface:Bitmap) 
	{
		for (i in 0...n)
		{
			surface.bitmapData.copyPixels(data, data.rect, p[i]);
		}
	}
}
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
class Attractor extends Entity implements IStepper
{
	public var data : BitmapData;
	
	public var n = 0;
	public var p = new Array<Point>();
	public var t = new Array<Int>();
	public var v = new Array<Point>();
	
	public var position = new Point();
	public var vitality = 0.0;
	public var radius = 0.0;
	public var strength = 0.0;
	public var lifetime : Int = 0;
	
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
				
				var z = 2 * Math.PI * Std.random(360) / 360;
				p[n] = Point.polar(radius, z).add(position);
				v[n].x = 0;
				v[n].y = 0;
				t[n] = lifetime;
				++n;
			}
			total_vitality -= count;
		}
		// Move
		for (i in 0...n)
		{
			t[i] -= 1;
			v[i] = position.subtract(p[i]);
			var z = strength / v[i].length;
			if (z > v[i].length) z = v[i].length;
			v[i].normalize(z);
			p[i].x += v[i].x;
			p[i].y += v[i].y;
		}
		// Clean
		var i = n - 1;
		while (i >= 0)
		{
			var done = position.subtract(p[i]).length;
			if ((t[i] <= 0) || (done <= 1))
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
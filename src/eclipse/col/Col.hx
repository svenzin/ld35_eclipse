package eclipse.col;
import eclipse.Level.PhxEntity;
import eclipse.col.Col.Hit;
import lde.Lde;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.geom.Point;

/**
 * ...
 * @author scorder
 */
class ColShape
{
	public var parent : PhxEntity = null;
}
class Hit
{
	public var shape : ColShape;
	public var depth : Point;
	
	public function new()
	{
		
	}
}
class Col extends Entity
{
	public function new() 
	{
		super();
	}
	
	public var objects = new List<Disk>();
	public function check(object : Disk) : List<Hit>
	{
		var colliders = new List<Hit>();
		var p1 = new Point(object.x, object.y);
		for (o in objects)
		{
			var hit = check_one(object, o);
			if (hit != null)
			{
				colliders.push(hit);
			}
		}
		return colliders;
	}
	public function check_one(_source : Disk, _other : Disk) : Hit
	{
		if (_other != _source)
		{
			var p1 = new Point(_source.x, _source.y);
			var p2 = new Point(_other.x, _other.y);
			var depth = (_source.r + _other.r) - Point.distance(p1, p2);
			if (depth >= 0)
			{
				var hit = new Hit();
				hit.shape = _other;
				hit.depth = p2.subtract(p1);
				hit.depth.normalize(depth);
				return hit;
			}
		}
		return null;
	}
	
	public var visible = false;
	override public function render(surface:Bitmap) 
	{
		if (visible)
		{
			var shape = new Shape();
			shape.graphics.lineStyle(1, Color.WHITE);
			for (o in objects)
			{
				shape.graphics.drawCircle(o.x, o.y, o.r);
			}
			surface.bitmapData.draw(shape);
		}
	}
}
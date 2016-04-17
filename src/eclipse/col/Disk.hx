package eclipse.col;
import eclipse.col.Col.ColShape;

/**
 * ...
 * @author scorder
 */
class Disk extends ColShape
{
	public var r : Float;
	public var x : Float;
	public var y : Float;
	public function new(xx, yy, rr, p = null) 
	{
		super(p);
		x = xx;
		y = yy;
		r = rr;
	}
}
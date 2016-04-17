package eclipse.gfx;
import lde.gfx.Animation;

/**
 * ...
 * @author scorder
 */
class PlanetsGfx
{
	static public var radius = [ 8, 12, 16, 20 ];
	static public function get(_slots : Int) : Animation
	{
		return new Animation([ Art.disk(radius[_slots], Std.random(0xffffff)) ]);
	}
}
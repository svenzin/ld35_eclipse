package eclipse.fx;
import eclipse.particle.Emitter;
import openfl.geom.Point;

/**
 * ...
 * @author scorder
 */
class Thrust extends Emitter
{
	public function new() 
	{
		super();
		data = Art.rect(1, 1, Color.GREY_25);
		dampen = 0.01;
		lifetime = 60;
		position = new Point(x, y);
		strength = 0.2;
		vitality = 0.5;
	}
	public function at(_x : Float, _y : Float)
	{
		position.x = _x;
		position.y = _y;
	}
	public function towards(_x : Float, _y : Float)
	{
		direction.x = _x;
		direction.y = _y;
		direction.normalize(0.5);
		is_active = (_x != 0 || _y != 0);
	}
}
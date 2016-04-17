package eclipse.fx;
import eclipse.Eclipse.IStepper;
import eclipse.particle.Emitter;
import lde.Key;
import lde.Lde;
import openfl.geom.Point;

/**
 * ...
 * @author scorder
 */
class Explosion implements IStepper
{
	public static function at(_position : Point)
	{
		new Explosion(_position);
	}
	
	public var emitter = new Emitter();
	public function new(_position : Point) 
	{
		emitter.data = Art.rect(2, 2, Color.YELLOW);
		emitter.position = _position;
		//emitter.direction;
		emitter.strength = 1.0;
		emitter.dampen = 0.1;
		emitter.lifetime = 20;
		emitter.vitality = 4;
		emitter.is_active = true;
		Lde.add(emitter);
		
		Eclipse.instance.steppers.add(this);
	}
	
	var phase = 0;
	public function step()
	{
		emitter.step();
		switch (phase)
		{
			case 0:
				{
					emitter.vitality = Std.int(emitter.vitality / 2);
					if (emitter.vitality == 0)
					{
						++phase;
					}
				}
			case 1:
				{
					if (emitter.n <= 0)
					{
						++phase;
					}
				}
			default:
				{
					Eclipse.instance.steppers.remove(this);
					Lde.remove(emitter);
				}
		}
	}
}
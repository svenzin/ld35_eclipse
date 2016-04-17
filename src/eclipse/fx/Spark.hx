package eclipse.fx;
import eclipse.Eclipse;
import eclipse.Eclipse.IStepper;
import eclipse.gfx.PartsGfx;
import eclipse.particle.Attractor;
import lde.Lde;
import lde.Lde.Entity;
import lde.gfx.Animation;
import openfl.geom.Point;
import eclipse.Level;

/**
 * ...
 * @author scorder
 */
class Spark implements IStepper
{
	public static function at(_position : Point, _callback : Part -> Void) 
	{
		new Spark(_position, _callback);
	}
	
	public var spark = new Entity();
	public var attractor = new Attractor();
	public var callback : Part -> Void;
	public var core = Part.make_core();
	public function new(_position : Point, _callback : Part -> Void) 
	{
		spark.x = _position.x;
		spark.y = _position.y;
		
		attractor.data = Art.rect(1, 1, Color.PURPLE);
		attractor.lifetime = 60;
		attractor.radius = 30;
		attractor.strength = 10;
		//attractor.vitality = 0.2;
		attractor.position = _position.add(new Point(PartsGfx.size / 2, PartsGfx.size / 2));
		
		core.moveTo(_position.x, _position.y);
		core.is_visible = false;
		
		callback = _callback;
		
		Eclipse.instance.steppers.add(this);
	}
	
	public function die()
	{
		callback(core);
		Eclipse.instance.steppers.remove(this);
		Lde.remove(attractor);
	}
	
	var phase = 0;
	var t = 0;
	public function step()
	{
		attractor.step();
		
		// Phases
		// Spark
		// Attractor
		// Part fade-in
		// Death
		
		switch (phase)
		{
			// Spark
			case 0:
				{
					spark.play(new Animation([
						Art.rect(16, 16, Color.WHITE),
						//Art.rect(16, 16, Color.GREY_25),
					])).speed(0.2);
					Lde.add(spark);
					++phase;
				}
			case 1:
				{
					if (spark.graphics.isDone())
					{
						attractor.is_active = true;
						t = 120;
						Lde.remove(spark);
						Lde.add(attractor);
						++phase;
					}
				}
			// Attractor
			case 2:
				{
					--t;
					attractor.vitality = 0.1 + Math.pow(1 - t / 120, 2);
					if (t <= 0)
					{
						attractor.is_active = false;
						Lde.add(core);
						++phase;
					}
				}
			case 3:
				{
					core.is_visible = (Lde.frame % 2) == 0;
					if (attractor.n <= 0)
					{
						++phase;
					}
				}
			// Death
			default:
				{
					core.is_visible = true;
					die();
				}
		}
	}
}
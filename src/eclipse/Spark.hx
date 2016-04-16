package src.eclipse;
import eclipse.particle.Attractor;

/**
 * ...
 * @author scorder
 */
class Spark
{
	public var attractor = new Attractor();
	public function new() 
	{
		attractor.data = Art.rect(2, 2, Color.PURPLE);
		attractor.lifetime = 120;
		attractor.position = emitter.position;
		attractor.radius = 30;
		attractor.strength = 10;
		attractor.vitality = 0.2;
	}
	
	public function die()
	{
		
	}
	
}
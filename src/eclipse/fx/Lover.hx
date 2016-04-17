package eclipse.fx;
import eclipse.Art;
import eclipse.gfx.PartsGfx;
import eclipse.particle.Emitter;
import lde.Lde;
import openfl.display.BitmapData;
import openfl.geom.Point;

/**
 * ...
 * @author scorder
 */
class Lover extends Emitter
{
	public function new() 
	{
		super();
		//data = PartsGfx.HEART;
		data = new BitmapData(3, 3, true, 0xffff00ff);
		//data.setPixel(0, 0, Color.PURPLE);
		data.setPixel32(1, 0, Color.TRANSPARENT);
		//data.setPixel(2, 0, Color.PURPLE);
		//data.setPixel(0, 1, Color.PURPLE);
		//data.setPixel(1, 1, Color.PURPLE);
		//data.setPixel(2, 1, Color.PURPLE);
		data.setPixel32(0, 2, Color.TRANSPARENT);
		//data.setPixel(1, 2, Color.PURPLE);
		data.setPixel32(2, 2, Color.TRANSPARENT);
		dampen = 0.00;
		lifetime = 150;
		position = new Point(x, y);
		strength = 0.2;
		vitality = 0.1;
		
		is_active = true;
		
		Lde.add(this);
		Eclipse.get().steppers.add(this);
	}
	
}
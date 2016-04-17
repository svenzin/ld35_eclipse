package eclipse;
import eclipse.Level.PhxEntity;
import lde.gfx.Animation;
import openfl.geom.Point;

/**
 * ...
 * @author scorder
 */
class Planet extends PhxEntity
{
	static var gfx = [
		new Animation([ Art.disk(_r, Color.GREEN) ]),
		new Animation([ Art.disk(_r, Color.GREEN) ]),
		new Animation([ Art.disk(_r, Color.GREEN) ]),
		new Animation([ Art.disk(_r, Color.GREEN) ]),
	];
	static var slots_position = [
		[ new Point() ],
		[ new Point() ],
		[ new Point() ],
		[ new Point() ],
	];
	public static function make(_slots : Int)
	{
		
	}
	public function new() 
	{
		
	}
	
}
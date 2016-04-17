package eclipse.level;
import eclipse.Eclipse.BaseLevel;
import eclipse.Level;

/**
 * ...
 * @author scorder
 */
class Root extends BaseLevel
{
	public var entities = new List<MyEntity>();
	override public function step():Void 
	{
		Controller.apply();
		
		for (e in entities)
		{
			e.vx = 0.9 * e.vx + e.ax;
			e.vy = 0.9 * e.vy + e.ay;
			e.moveBy(e.vx, e.vy);
		}
	}

	public function new() 
	{
	}
	
}
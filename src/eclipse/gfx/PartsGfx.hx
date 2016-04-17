package eclipse.gfx;
import haxe.macro.Expr.Position;
import lde.gfx.Animation;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author scorder
 */
class PartsGfx
{
	public static var size = 9;
	
	public static var EMPTY : Animation;
	public static var EMPTY_TO_PART : Animation;
	public static var PART : Animation;
	public static var PART_TO_LIFE : Animation;
	public static var LIFE : Animation;
	
	public static var KOA : Animation;
	public static var KOA_BURST : Animation;
	public static var CANNON : Animation;
	public static var CANNON_BURST : Animation;
	public static var SHIELD : Animation;
	public static var SHIELD_BURST : Animation;
	public static var SOURCE : Animation;
	public static var SOURCE_BURST : Animation;

	static var data : BitmapData = null;
	public static function load()
	{
		if (data == null)
		{
			data = Assets.getBitmapData("img/parts.png");
			
			EMPTY         = new Animation(slice([ [0, 1] ]));
			EMPTY_TO_PART = new Animation(slice([ [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7] ]));
			PART          = new Animation(slice([ [0, 0] ]));
			PART_TO_LIFE  = new Animation(slice([ [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7] ]));
			LIFE          = new Animation(slice([ [0, 2] ]));
			
			KOA          = new Animation(slice([ [3, 0] ]));
			KOA_BURST    = new Animation(slice([ [3, 1], [3, 2] ]));
			CANNON       = new Animation(slice([ [4, 0] ]));
			CANNON_BURST = new Animation(slice([ [4, 1], [4, 2] ]));
			SHIELD       = new Animation(slice([ [5, 0] ]));
			SHIELD_BURST = new Animation(slice([ [5, 1], [5, 2] ]));
			SOURCE       = new Animation(slice([ [6, 0] ]));
			SOURCE_BURST = new Animation(slice([ [6, 1], [6, 2] ]));
		}
	}
	static function tile(_x : Int, _y : Int)
	{
		var tile = new BitmapData(size, size);
		tile.copyPixels(data, new Rectangle(size * _x, size * _y, size, size), new Point());
		return tile;
	}
	static function slice(_list : Array<Array<Int>>)
	{
		var frames = new Array<BitmapData>();
		for (p in _list)
		{
			frames.push(tile(p[0], p[1]));
		}
		return frames;
	}
}
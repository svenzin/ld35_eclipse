package eclipse;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Rectangle;

/**
 * ...
 * @author scorder
 */
class Art
{
	//public static var CORE
	public static function rect(w : Int, h : Int, c : Int)
	{
		return new BitmapData(w, h, false, c);
	}

	public static function disk(r : Int, c : Int)
	{
		var shape = new Shape();
		shape.graphics.beginFill(c);
		shape.graphics.drawCircle(r, r, r);
		
		var data = new BitmapData(2 * r, 2 * r, true, Color.TRANSPARENT);
		data.draw(shape);
		return data;
	}
}
package lde.gfx;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;

/**
 * ...
 * @author scorder
 */
class Animation
{
	public var frames : Array<BitmapData>;
	public function new(f : Array<BitmapData> = null)
	{
		if (f == null) frames = new Array<BitmapData>();
		else frames = f;
	}
	public function renderFrameAt(i : Int, p : Point, surface : Bitmap)
	{
		surface.bitmapData.copyPixels(frames[i], frames[i].rect, p);
	}
}

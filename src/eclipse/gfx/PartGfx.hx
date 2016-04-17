package eclipse.gfx;
import eclipse.Eclipse.PartsType;
import lde.Lde;
import lde.gfx.AnimationPlayback;
import openfl.display.Bitmap;
import openfl.geom.Point;

/**
 * ...
 * @author scorder
 */
class PartGfx extends Entity
{
	public var bg : AnimationPlayback;
	public var fg : AnimationPlayback;
	public var type : PartsType;
	
	public function new()
	{
		super();
	}
	override public function render(surface:Bitmap) 
	{
		if (is_visible)
		{
			var p = new Point(x, y);
			if (bg != null) bg.renderAt(p, surface);
			if (fg != null) fg.renderAt(p, surface);
		}
	}
}
class EmptyPart extends PartGfx
{
	public function new()
	{
		super();
		type = PartsType.EMPTY;
		bg = new AnimationPlayback(PartsGfx.EMPTY).play();
		fg = null;
	}
}
class CorePart extends PartGfx
{
	public function new()
	{
		super();
		type = PartsType.CORE;
		bg = new AnimationPlayback(PartsGfx.PART).play();
		fg = new AnimationPlayback(PartsGfx.KOA).play();
	}
}

package lde;
import openfl.Lib;
import openfl.events.Event;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import lde.gfx.Animation;
import lde.gfx.AnimationPlayback;

/**
 * ...
 * @author scorder
 */
class Entity
{
	public function new()
	{
		is_visible = true;
		graphics = null;
	}
	public var x : Float;
	public var y : Float;
	
	public var is_visible : Bool;
	public var graphics : AnimationPlayback;
	public function play(animation : Animation)
	{
		graphics = new AnimationPlayback(animation);
		return graphics.play();
	}
	public function render(surface : Bitmap)
	{
		if (graphics != null && is_visible)
		{
			graphics.renderAt(new Point(x, y), surface);
		}
	}
}
interface IGame
{
	public var WIDTH : Int;
	public var HEIGHT : Int;
	public var SCALE : Int;
	public function init() : Void;
	public function step() : Void;
}
class Pointer
{
	public static var x : Float;
	public static var y : Float;
	
	public static function init()
	{
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
	}
	
	static function onMove(ptr : MouseEvent)
	{
		x = ptr.stageX / Lde._scale;
		y = ptr.stageY / Lde._scale;
	}
	
	public static function step()
	{
		
	}
}
class Lde
{
	static var _game : IGame;
	public static function run(game : IGame)
	{
		_game = game;
		init(_game.WIDTH, _game.HEIGHT, _game.SCALE);
	}
	
	public static var objects : List<Entity>;
	public static var removed : List<Entity>;
	static public function add(object : Entity)
	{
		objects.add(object);
	}
	static public function remove(object : Entity)
	{
		removed.add(object);
	}
	static public function cleanup()
	{
		for (o in removed) objects.remove(o);
	}
	
	public static var hud : List<Entity>;
	
	public static var _width : Float;
	public static var _height : Float;
	public static var _scale : Float;
	public static var visible : Bool;
	static var surface : Bitmap;
	static public function init(width : Int, height : Int, scale : Int = 1)
	{
		_width = width;
		_height = height;
		_scale = scale;
		
		var data = new BitmapData(width, height, false);
		surface = new Bitmap(data, "always", false);
		surface.x = 0;
		surface.y = 0;
		surface.scaleX = scale;
		surface.scaleY = scale;
		
		visible = true;
		
		objects = new List<Entity>();
		removed = new List<Entity>();
		
		hud = new List<Entity>();
		
		Lib.current.stage.addChild(surface);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, step);
		
		Key.init();
		Pointer.init();
		
		_game.init();
	}
	
	public static var frame = 0;
	static public function step(_)
	{
		_game.step();
		
		cleanup();
		
		++frame;
		
		surface.bitmapData.fillRect(surface.bitmapData.rect, 0x000000);
		if (visible)
		{
			for (object in objects)
			{
				object.render(surface);
			}
		}
		for (object in hud)
		{
			object.render(surface);
		}
		
		Key.step();
		Pointer.step();
	}
}
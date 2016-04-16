package eclipse;
import eclipse.Level;
import eclipse.util.Debug;
import lde.Lde;
import lde.gfx.Animation;
import openfl.Lib;

/**
 * ...
 * @author scorder
 */
enum PartsType
{
	EMPTY;
	CORE;
	CANNON;
	SHIELD;
	SOURCE;
}
class Parts
{
	public static var size = 8;
	
	public static var CORE : Animation;
	public static var EMPTY : Animation;
	
	public static function load()
	{
		CORE = new Animation([ Art.rect(8, 8, Color.RED) ]);
		EMPTY = new Animation([ Art.rect(size, size, Color.GREY_50) ]);
	}
}
class Part
{
	public var type : PartsType;
	
	public function new(_type : PartsType)
	{
		type = _type;
	}
}
class Eclipse implements IGame
{
	public var WIDTH : Int = 256;
	public var HEIGHT : Int = 256;
	public var SCALE : Int = 2;
	
	var info = new Debug(10, 10, Color.WHITE);
	
	var level : Level = null;
	
	public function init()
	{
		info.visible = true;
		Lib.current.stage.addChild(info);
		
		Parts.load();
	}
	
	public function step()
	{
		info.update();
		
		if (level == null)
		{
			level = new Level();
			level.init();
		}
		level.step();
	}
	
	public function new() 
	{
		
	}
	
}
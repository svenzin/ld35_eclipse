package eclipse;
import eclipse.Level;
import eclipse.level.*;
import eclipse.col.Col;
import eclipse.gfx.PartsGfx;
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
	UNKNOWN;
	
	EMPTY;
	CORE;
	CANNON;
	SHIELD;
	SOURCE;
}
interface IStepper
{
	function step() : Void;
}
class BaseLevel
{
	static public var ONGOING = 1;
	static public var VICTORY = 2;
	static public var DEFEAT = 3;
	
	public var next : BaseLevel = null;
	public var state = ONGOING;
	public function init() : Void {}
	public function step() : Void {}
}
class Eclipse implements IGame
{
	public var WIDTH : Int = 300;
	public var HEIGHT : Int = 200;
	public var SCALE : Int = 3;
	
	var info = new Debug(10, 10, Color.WHITE);
	
	var level : BaseLevel = null;
	
	public function init()
	{
		info.visible = true;
		Lib.current.stage.addChild(info);
		
		Lde.hud.add(collider);
		
		PartsGfx.load();
	}
	
	public var collider = new Col();
	public var steppers = new List<IStepper>();
	public function step()
	{
		info.update();
		
		if (level == null)
		{
			level = new Level1();
			level.init();
		}
		
		if (level.state == BaseLevel.ONGOING)
		{
			level.step();
		}
		else if (level.state == BaseLevel.DEFEAT)
		{
			level = null;
		}
		else if (level.state == BaseLevel.VICTORY)
		{
			level = level.next;
			if (level != null) level.init();
		}
		
		for (stepper in steppers)
		{
			stepper.step();
		}
	}
	
	static public var instance : Eclipse;
	public function new() 
	{
		instance = this;
	}
	static public function get() { return instance; }
	
}
package lde;

import openfl.Lib;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author scorder
 */
class Key
{
	static var down : Array<Bool>;
	static var pushed : Array<Bool>;
	static var released : Array<Bool>;
	
	public static function isDown(key : Int) { return down[key]; }
	public static function isUp(key : Int) { return !isDown(key); }
	public static function isPushed(key : Int) { return pushed[key]; }
	public static function isReleased(key : Int) { return released[key]; }
	
	public static function init()
	{
		down = new Array();
		pushed = new Array();
		released = new Array();
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	
	static function keyDown(key : KeyboardEvent)
	{
		if (!down[key.keyCode])
		{
			down[key.keyCode] = true;
			pushed[key.keyCode] = true;
		}
	}
	
	static function keyUp(key : KeyboardEvent) 
	{
		if (down[key.keyCode])
		{
			down[key.keyCode] = false;
			released[key.keyCode] = true;
		}
	}
	
	public static function step()
	{
		pushed = new Array();
		released = new Array();
	}
}
package lde.gfx;
import openfl.display.Bitmap;
import openfl.geom.Point;
/**
 * ...
 * @author scorder
 */
class AnimationPlayback
{
	public var _animation : Animation;
	public function new(animation : Animation)
	{
		_animation = animation;
		
		_t0 = 0;
		_x = 0;
		_v = 1;
		_running = true;
		_loop = false;
	}
	public function renderAt(p : Point, surface : Bitmap)
	{
		var frame = update();
		_animation.renderFrameAt(frame, p, surface);
	}
	public var _t0 : Int;
	public var _x : Float;
	public var _v : Float;
	public var _n : Int;
	public var _running: Bool;
	public var _loop : Bool;
	public function repeat(count : Int) { _n = count; _t0 = Lde.frame; return this; }
	public function play() { return repeat(1); }
	public function loop() { _loop = true; return play(); }
	public function speed(v : Float) { _v = v; _t0 = t0(Lde.frame, _x); return this; }
	public function pause() { _running = false; return this; }
	public function resume() { _running = true; _t0 = t0(Lde.frame, _x); return this; }
	public function seek(x : Float) { _x = x; return this; }
	function x(t : Int, t0 : Int) { return (t - t0) / _animation.frames.length * _v; }
	function t0(t : Int, x : Float) { return Std.int(t - x * _animation.frames.length / _v); }
	function update()
	{
		if (_running && _loop)
		{
			_x = x(Lde.frame, _t0);
			_x = _x - Std.int(_x);
		}
		else if (_running && _n > 0)
		{
			_x = x(Lde.frame, _t0);
			_n -= Std.int(_x);
			_x = _x - Std.int(_x);
			if (_n <= 0)
			{
				_x = 0.99;
				_n = 0;
				pause();
			}
		}
		return Std.int(_animation.frames.length * _x);
	}
}

package eclipse;
import eclipse.Eclipse.IStepper;

/**
 * ...
 * @author scorder
 */
class Tween implements IStepper
{
	static function nothing(x : Float) {}
	static public function wait(_duration : Int)
	{
		return new Tween(_duration, nothing);
	}

	var t0 : Int;
	var t : Int;
	var action : Float -> Void;
	var complete : Void -> Void;
	public function new(_duration : Int,
	                    _action : Float -> Void)
	{
		Eclipse.instance.steppers.add(this);
		t0 = _duration;
		t = 0;
		action = _action;
		complete = null;
	}
	public function then(_action : Void -> Void)
	{
		complete = _action;
	}
	public function step()
	{
		if (t > t0)
		{
			kill();
		}
		else
		{
			action(t / t0);
		}
		++t;
	}
	public function kill()
	{
		if (complete != null) complete();
		Eclipse.instance.steppers.remove(this);
	}
}
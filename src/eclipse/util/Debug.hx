package eclipse.util;

import haxe.Timer;
import lde.Lde;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
 * ...
 * @author scorder
 */
class Debug extends TextField
{
	public var times : Array<Float>;
	public var memPeak : Float = 0;

	public function new(xx : Float, yy : Float, c : Int) 
	{
		super();
		
		x = xx;
		y = yy;
		selectable = false;
		
		defaultTextFormat = new TextFormat("_sans", 12, c);
		
		times = [];
		width = 150;
		height = 150;
	}
	
	public function update()
	{	
		var now = Timer.stamp();
		times.push(now);
		
		while (times[0] < now - 1)
			times.shift();
			
		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100)/100;
		if (mem > memPeak) memPeak = mem;
		
		if (visible)
		{	
			text = "FPS: " + times.length + "\n"
				+ "MEM: " + mem + " MB\n"
				+ "MEM peak: " + memPeak + " MB\n"
				+ "Entities: " + Lde.objects.length + "\n"
				+ "Colliders: " + Eclipse.instance.collider.objects.length + "\n"
				+ "Steppers: " + Eclipse.instance.steppers.length;
		}
	}
	
}
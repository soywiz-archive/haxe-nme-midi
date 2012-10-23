package midi;
import haxe.Timer;

/**
 * ...
 * @author soywiz
 */

class MidiTimer 
{
	var startTime:Float;
	var endTime:Float;
	var running:Bool;
	
	public function new() 
	{
		stop();
	}
	
	private function getStamp():Float {
		return Timer.stamp();
	}
	
	public function start() {
		running = true;
		startTime = getStamp();
	}
	
	public function stop() {
		running = false;
		startTime = endTime = 0;
		//endTime = getStamp();
	}
	
	public function getRunning():Bool {
		return running;
	}
	
	public function getElapsedMs():Int {
		var last:Float = running ? getStamp() : endTime;
		return Std.int((last - startTime) * 1000);
	}
}
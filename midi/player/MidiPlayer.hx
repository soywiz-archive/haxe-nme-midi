package midi.player;
import haxe.Timer;
import midi.MidiTimer;

/**
 * ...
 * @author soywiz
 */

class MidiPlayer 
{
	var midi:Midi;
	var trackPlayers:Array<MidiTrackPlayer>;
	var timer:MidiTimer;

	public function new(_midi:Midi) 
	{
		this.midi = _midi;
		this.timer = new MidiTimer();
		
		this.trackPlayers = [];
		for (track in this.midi.tracks) {
			if (track.events.length > 0) {
				trackPlayers.push(new MidiTrackPlayer(track));
			}
		}
	}
	
	private function playTick():Void {
		var elapsedMs = timer.getElapsedMs();
		{
			//trace(elapsedMs + " : " + timer.getRunning());
			//trace('----------- : ' + trackPlayers.length);
			for (trackPlayer in trackPlayers) {
				trackPlayer.executeUpTo(elapsedMs);
			}
		}
		if (timer.getRunning()) Timer.delay(playTick, 10);
	}

	public function play():Void {
		timer.start();
		playTick();
	}
	
	public function stop():Void {
		timer.stop();
	}
}
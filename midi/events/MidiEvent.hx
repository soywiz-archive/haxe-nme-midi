package midi.events;

/**
 * ...
 * @author soywiz
 */

class MidiEvent 
{
	public var time:Int;
	public var track:MidiTrack;

	public function new(time:Int, track:MidiTrack)
	{
		this.time = time;
		this.track = track;
	}
	
	public function execute(midiTrackPlayer:midi.player.MidiTrackPlayer):Void {
	}
}
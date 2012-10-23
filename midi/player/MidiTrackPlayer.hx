package midi.player;
import midi.events.MidiEvent;

/**
 * ...
 * @author soywiz
 */

class MidiTrackPlayer 
{
	var nextEventIndex:Int = 0;
	var midiTrack:MidiTrack;
	public var bank:Int;
	public var modulation:Float;
	public var notes:Array<MidiNote>;

	public function new(midiTrack:MidiTrack) 
	{
		this.midiTrack = midiTrack;
		this.notes = [];
		for (noteId in 0 ... 127) notes.push(new MidiNote(noteId));
	}
	
	public function executeUpTo(timeMs:Int) {
		//trace("tick: " + timeMs);
		while ((nextEventIndex < midiTrack.events.length) && (midiTrack.events[nextEventIndex].time <= timeMs)) {
			// Execute Event
			var event:MidiEvent = midiTrack.events[nextEventIndex++];
			trace("  #" + midiTrack.id + ": " + event.time + ": " + event);
			event.execute(this);
		}
	}
}
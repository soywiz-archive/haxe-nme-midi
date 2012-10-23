package midi.events;

/**
 * ...
 * @author soywiz
 */

class MidiEventNoteAftertouch extends MidiEvent
{
	public var noteNumber:Int;
	public var value:Int;

	public function new(time:Int, track:MidiTrack, set:Bool, noteNumber:Int, value:Int)
	{
		super(time, track);
		this.noteNumber = noteNumber;
		this.value = value;
	}
	
	override public function execute(midiTrackPlayer:midi.player.MidiTrackPlayer):Void {
	}
}
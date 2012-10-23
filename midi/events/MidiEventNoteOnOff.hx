package midi.events;

/**
 * ...
 * @author soywiz
 */

class MidiEventNoteOnOff extends MidiEvent
{
	public var set:Bool;
	public var noteNumber:Int;
	public var velocity:Int;

	public function new(time:Int, track:MidiTrack, set:Bool, noteNumber:Int, velocity:Int)
	{
		super(time, track);
		this.set = set;
		this.noteNumber = noteNumber;
		this.velocity = velocity;
	}
	
	override public function execute(midiTrackPlayer:midi.player.MidiTrackPlayer):Void {
		midiTrackPlayer.notes[noteNumber].setVelocity(set, velocity / 127);
	}
	
	public function toString() {
		return Std.format("MidiEventNoteOnOff(on=$set, note=$noteNumber, velocity=$velocity)");
	}
}
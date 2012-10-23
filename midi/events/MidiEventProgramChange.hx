package midi.events;

/**
 * ...
 * @author soywiz
 */

class MidiEventProgramChange extends MidiEvent
{
	public var programNumber:Int;

	public function new(time:Int, track:MidiTrack, programNumber:Int)
	{
		super(time, track);
		this.programNumber = programNumber;
	}
	
	override public function execute(midiTrackPlayer:midi.player.MidiTrackPlayer):Void {
	}
	
	public function toString() {
		return Std.format("MidiEventProgramChange($programNumber)");
	}
}
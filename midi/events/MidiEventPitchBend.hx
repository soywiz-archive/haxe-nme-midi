package midi.events;

/**
 * ...
 * @author soywiz
 */

class MidiEventPitchBend extends MidiEvent
{
	public var pitch:Int;

	public function new(time:Int, track:MidiTrack, pitch:Int)
	{
		super(time, track);
		this.pitch = pitch;
	}
	
	override public function execute(midiTrackPlayer:midi.player.MidiTrackPlayer):Void {
	}
}
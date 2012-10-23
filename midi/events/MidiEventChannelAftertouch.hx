package midi.events;

/**
 * ...
 * @author soywiz
 */

class MidiEventChannelAftertouch extends MidiEvent
{
	public var value:Int;

	public function new(time:Int, track:MidiTrack, value:Int)
	{
		super(time, track);
		this.value = value;
	}
	
	override public function execute(midiTrackPlayer:midi.player.MidiTrackPlayer):Void {
	}
}
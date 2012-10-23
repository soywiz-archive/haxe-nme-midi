package midi.events;

/**
 * ...
 * @author soywiz
 */

class MidiEventData extends MidiEvent
{
	public var dataId:Int;
	public var value1:Int;
	public var value2:Int;

	public function new(time:Int, track:MidiTrack, dataId:Int, value1:Int, value2:Int)
	{
		super(time, track);
		this.dataId = dataId;
		this.value1 = value1;
		this.value2 = value2;
	}
	
	override public function execute(midiTrackPlayer:midi.player.MidiTrackPlayer):Void {
	}
	
	public function toString() {
		return Std.format("MidiEventData($dataId, $value1, $value2)");
	}
}
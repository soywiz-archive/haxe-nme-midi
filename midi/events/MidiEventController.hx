package midi.events;

/**
 * ...
 * @author soywiz
 */

class MidiEventController extends MidiEvent
{
	public var controllerId:Int;
	public var value:Int;

	public function new(time:Int, track:MidiTrack, controllerId:Int, value:Int)
	{
		super(time, track);
		this.controllerId = controllerId;
		this.value = value;
	}
	
	override public function execute(midiTrackPlayer:midi.player.MidiTrackPlayer):Void {
		switch (controllerId) {
			case 0x00: // BankSelect
				midiTrackPlayer.bank = value;
			case 0x01: // Modulation
				midiTrackPlayer.modulation = (value / 127);
		}
	}
	
	static public function getControllerName(controllerId:Int):String {
		return switch(controllerId) {
			case 0x00: "BankSelect";
			default: "Unknown" + controllerId;
		};
	}
	
	public function toString() {
		return Std.format("MidiEventController(${getControllerName(controllerId)} = $value)");
	}
}
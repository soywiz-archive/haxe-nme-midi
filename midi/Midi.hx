package midi;
import nme.errors.Error;
import nme.utils.ByteArray;
import nme.utils.Endian;

/**
 * ...
 * @author soywiz
 */

class Midi 
{
	public var formatType:Int;
	public var tracks:Array<MidiTrack>;
	public var msMultiplier:Float;

	private function new(data:ByteArray)
	{
		load(data);
	}
	
	private function load(data:ByteArray)
	{
		data.endian = Endian.BIG_ENDIAN;
		var magic:String = data.readUTFBytes(4);
		var chunkSize:Int = data.readUnsignedInt();
		if (magic != "MThd") throw(new Error("Invalid MIDI file '" + magic + "'"));
		if (chunkSize != 6) throw(new Error("Invalid MIDI header : chunkSize != 6 : " + chunkSize));
		var chunk:ByteArray = new ByteArray();
		chunk.position = 0;
		data.readBytes(chunk, 0, chunkSize);

		formatType = chunk.readUnsignedShort();
		var tracksCount:Int = chunk.readUnsignedShort();
		var timeDivision:Int = chunk.readUnsignedShort();
		if (formatType < 0 || formatType > 2) throw(new Error("Invalid MIDI header. Invalid FormatType"));
		if (tracksCount == 0) throw(new Error("Invalid MIDI header tracksCount == 0"));
		if ((timeDivision & 0x8000) == 0) {
			var value:Int = (timeDivision & 0x7FFF);
			trace('ticks per beat : ' + value);
			msMultiplier = (1000 / value) / 2;
		} else {
			var SMPTE:Int = (timeDivision >> 8) & 0x7F;
			var clocksPerFrame:Int = (timeDivision >> 0) & 0xFF;
			trace('frames per second ' + SMPTE + '/' + clocksPerFrame);
			throw(new Error("Not implemented frames per second midi"));
		}
		
		tracks = [];
		for (trackId in 0 ... tracksCount) {
			tracks[trackId] = MidiTrack.fromByteArray(this, data, trackId);
		}
	}
	
	static public function fromByteArray(data:ByteArray):Midi {
		return new Midi(data);
	}
}
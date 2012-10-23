package midi;
import haxe.Log;
import midi.events.MidiEvent;
import midi.events.MidiEventChannelAftertouch;
import midi.events.MidiEventController;
import midi.events.MidiEventData;
import midi.events.MidiEventNoteAftertouch;
import midi.events.MidiEventNoteOnOff;
import midi.events.MidiEventPitchBend;
import midi.events.MidiEventProgramChange;
import nme.errors.Error;
import nme.utils.ByteArray;
import nme.utils.Endian;

/**
 * ...
 * @author soywiz
 */

class MidiTrack 
{
	public var id:Int;
	public var _midi:Midi;
	public var events:Array<MidiEvent>;
	
	private function new(_midi:Midi, data:ByteArray, id:Int = -1) 
	{
		this._midi = _midi;
		this.events = [];
		this.id = id;
		load(data);
	}
	
	private function trace2(v:Dynamic) {
		//trace(v);
	}
	
	private function load(data:ByteArray) {
		trace2('TRACK:');
		var magic:String = data.readUTFBytes(4);
		var chunkSize:Int = data.readUnsignedInt();
		var chunkData:ByteArray = readByteArrayLength(data, chunkSize);
		var sequenceNumber:Int = 0;
		var channelPrefix:Int = 0;
		var eventTime:Int = 0;
		
		//while (chunkData.bytesAvailable > 0) {
		while (chunkData.position < chunkData.length) {
			trace2(chunkData.position + "/" + chunkData.length);
			var deltaTime:Int = readVariableLength(chunkData);
			trace2(chunkData.position + "/" + chunkData.length);
			var eventTypeMidiChannel:Int = chunkData.readUnsignedByte();
			trace2(chunkData.position + "/" + chunkData.length);
			eventTime += deltaTime;
			
			if (chunkData.position >= chunkData.length) {
				trace2("aaaaaaaaaa");
				break;
			}
			
			trace2(eventTypeMidiChannel);
			
			if (eventTypeMidiChannel == 0xFF) {
				// Meta Event
				var type:Int = chunkData.readUnsignedByte();
				var eventLength:Int = readVariableLength(chunkData);
				var eventData:ByteArray = readByteArrayLength(chunkData, eventLength);
				switch (type) {
					// Sequence number
					case 0:
						sequenceNumber = eventData.readUnsignedShort();
					// Text event
					case 1:
						trace2("Text: '" + eventData + "'");
					// Copyright notice
					case 2:
						trace2("Copyright: '" + eventData + "'");
					// Sequence/track name
					case 3:
						trace2("TrackName: '" + eventData + "'");
					// Instrument Name
					case 4:
						trace2("InstrumentName: '" + eventData + "'");
					// Lyrics
					case 5:
						trace2("Lyrics: '" + eventData + "'");
					// Marker
					case 6:
						trace2("Marker: '" + eventData + "'");
					// CuePoint
					case 7:
						trace2("CuePoint: '" + eventData + "'");
					// MIDI Channel Prefix
					case 32:
						channelPrefix = eventData.readUnsignedByte();
					// End Of Track
					case 47:
						trace2("EndOfTrack");
					default:
						trace2("Meta-Event: " + type + " : " + eventData);
				}
			} else if ((eventTypeMidiChannel == 0xF0) || (eventTypeMidiChannel == 0xF7)) {
				// System Exclusive Events
				var eventLength:Int = readVariableLength(chunkData);
				var eventData:ByteArray = readByteArrayLength(chunkData, eventLength);
				trace2(" System Exclusive Event");
			} else {
				// Event
				var eventType:Int = (eventTypeMidiChannel >> 4) & 0xF;
				var midiChannel:Int = (eventTypeMidiChannel >> 0) & 0xF;
				var param1:Int = chunkData.readUnsignedByte();
				var param2:Int = chunkData.readUnsignedByte();
				var event:MidiEvent;
				var eventTimeMs:Int = Std.int(eventTime * _midi.msMultiplier);
				switch (eventType) {
					case 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7:
						event = (new MidiEventData(eventTimeMs, this, eventType, param1, param2));
					case 0x8: event = (new MidiEventNoteOnOff(eventTimeMs, this, false, param1, param2));
					case 0x9: event = (new MidiEventNoteOnOff(eventTimeMs, this, true, param1, param2));
					case 0xA: event = (new MidiEventNoteAftertouch(eventTimeMs, this, true, param1, param2));
					case 0xB: event = (new MidiEventController(eventTimeMs, this, param1, param2));
					case 0xC: event = (new MidiEventProgramChange(eventTimeMs, this, param1));
					case 0xD: event = (new MidiEventChannelAftertouch(eventTimeMs, this, param1));
					case 0xE: event = (new MidiEventPitchBend(eventTimeMs, this, (param1 << 8) | (param2)));
					default: throw new Error("Unknown Event: " + deltaTime + " : " + eventType + " : " + midiChannel + " : " + param1 + " : " + param2);
				}
				events.push(event);
			}
		}
		trace2("");
	}
	
	static private function readVariableLength(data:ByteArray):Int {
		var value = 0;
		var byte:Int = 0;
		do {
			byte = data.readUnsignedByte();
			value <<= 7;
			value |= (byte & 0x7F);
		} while ((byte & 0x80) != 0);
		return value;
	}
	
	static private function readByteArrayLength(data:ByteArray, length:Int):ByteArray {
		var sub:ByteArray = new ByteArray();
		sub.endian = Endian.BIG_ENDIAN;
		if (length > 0) {
			data.readBytes(sub, 0, length);
		}
		sub.position = 0;
		return sub;
	}
	
	static public function fromByteArray(_midi:Midi, data:ByteArray, id:Int = -1):MidiTrack {
		return new MidiTrack(_midi, data, id);
	}
}
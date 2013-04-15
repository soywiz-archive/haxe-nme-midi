package wildmidi;
import nme.utils.ByteArray;

typedef UByte = Int;
typedef UShort = Int;
typedef SShort = Int;

/**
 * ...
 * @author ...
 */
class Sample
{
	public var data_length:Int;
	public var loop_start:Int;
	public var loop_end:Int;
	public var loop_size:Int;
	public var loop_fraction:UByte;
	public var rate:UShort;
	public var freq_low:Int;
	public var freq_high:Int;
	public var freq_root:Int;
	public var modes:UByte;
	public var env_rate:Array<Int>; // length: 7
	public var env_target:Array<Int>; // length: 7
	public var inc_div:Int;
	public var data:ByteArray; // Array<SShort>
	public var next:Sample;
	
	public function new() {
		this.env_rate = [0, 0, 0, 0, 0, 0, 0];
		this.env_target = [0, 0, 0, 0, 0, 0, 0];
	}
}
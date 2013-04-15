package wildmidi;
import nme.utils.ByteArray;

typedef UByte = Int;
typedef UShort = Int;
typedef SShort = Int;

/**
 * ...
 * @author ...
 */
class Patch
{
	public var patchid:UShort;
	public var loaded:UByte;
	public var filename:String;
	public var amp:SShort;
	public var keep:UByte;
	public var remove:UByte;
	public var env:Array<Env>; // length:6
	public var note:UByte;
	public var inuse_count:Int;
	public var first_sample:Sample;
	public var next:Patch;
}
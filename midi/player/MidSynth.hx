package midi.player;

/**
 * ...
 * @author soywiz
 */

class MidSynth 
{
	public var octaves:Array<Array<Float>>;
	public var sample:Array<Float>;

	static public inline var NOTE_C = 0;
	static public inline var NOTE_CS = 1;
	static public inline var NOTE_D = 2;
	static public inline var NOTE_DS = 3;
	static public inline var NOTE_E = 4;
	static public inline var NOTE_F = 5;
	static public inline var NOTE_FS = 6;
	static public inline var NOTE_G = 7;
	static public inline var NOTE_GS = 8;
	static public inline var NOTE_A = 9;
	static public inline var NOTE_AS = 10;
	static public inline var NOTE_B = 11;
	
	static public inline var OCTAVE_COUNT = 10;
	
	static public inline var SAMPLE_COUNT = 0x10000;
	
	static public inline var POW_2_1__12 = Math.pow(2, (1 / 12)); // 2^(1/12)

	static private var instance:MidSynth;
	static public function getInstance():MidSynth {
		if (instance == null) instance = new MidSynth();
		return instance;
	}
	
	private function new() 
	{
		createSample();
		createOctaves();
	}
	
	private function createSample() {
		sample = [];
		
        var maxAt:Int = Std.int(SAMPLE_COUNT / 16);
		for (i in 0 ... SAMPLE_COUNT) {
			var value:Float = 0;
			if (i < maxAt) {
				value = i / (maxAt) * 2.0 - 1.0;
			} else {
				value = 1.0 - ((i - maxAt)) / ((SAMPLE_COUNT - maxAt)) * 2.0;
			}
			sample[i] = value;
        }
	}
	
	private function createOctaves() {
		var base:Float = 40.0;
		octaves = [];
		for (i in 0 ... OCTAVE_COUNT) {
			octaves.push(createPitches(base));
			base *= 2;
		}
	}
	
	public function getPitchFromNoteId(noteId:Int):Float {
		return octaves[Std.int(noteId / 12)][Std.int(noteId % 12)];
	}
	
	/**
	 * calculate current value of attack/delay/sustain/release envelope
	 * 
	 * @param	time
	 * @param	duration
	 * @return
	 */
	static public function adsr(time:Float, duration:Float):Float {
		if (time < 0.0) return 0.0;

		var attack:Float = 0.004;
		var decay:Float = 0.02;
		var sustain:Float = 0.5;
		var release:Float = 0.08;

		duration -= attack + decay + release;
		if (time < attack) return time / attack;
		time -= attack;
		if (time < decay) return (decay - time) / decay * (1.0 - sustain) + sustain;
		time -= decay;
		if (time < duration) return sustain;
		time -= duration;
		if (time < release) return (release - time) / release * sustain;
		return 0.0;
	}

	
	static private function createPitches(base:Float):Array<Float> {
		var pitches:Array<Float> = [];
		for (i in 0 ... 12) {
			pitches.push(base);
			base *= POW_2_1__12;  // 2^(1/12)
        }
		return pitches;
	}
	
}
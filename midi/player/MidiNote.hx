package midi.player;
import nme.events.SampleDataEvent;
import nme.media.Sound;
import nme.media.SoundChannel;

/**
 * ...
 * @author soywiz
 */

class MidiNote 
{
	public var noteId:Int;
	private var playing:Bool;
	private var sound:Sound = null;
	private var soundChannel:SoundChannel = null;
	private var velocity:Float;
	private var synth:midi.player.MidSynth;
	private var currentSampleIndex:Float = 0;
	static private inline var PI_2 = Math.PI / 2;

	public function new(noteId:Int) 
	{
		synth = midi.player.MidSynth.getInstance();
		playing = false;
	}
	
	function getSampleIncrement() {
		return synth.getPitchFromNoteId(noteId) * (synth.sample.length / 44100);
	}

	function sineWaveGenerator(event:SampleDataEvent):Void {
		var sampleCount = Std.int(8192 / 4);
		var data = event.data;
		
		if (velocity <= 0) {
			for (c in 0 ... sampleCount) {
				data.writeFloat(0);
				data.writeFloat(0);
			}
		} else {
			var sampleIncrement = getSampleIncrement();
			//for (c in 0 ... 2 * 8192) {
			for (c in 0 ... sampleCount) {
				//var offset = c + event.position;
				var value:Float = synth.sample[Std.int(currentSampleIndex)] * velocity;
				
				currentSampleIndex += sampleIncrement;
				if (currentSampleIndex >= synth.sample.length) currentSampleIndex -= synth.sample.length;
				
				data.writeFloat(value);
				data.writeFloat(value);
			}
		}
	}
	
	private function pauseChannel() {
		if (soundChannel != null) {
			soundChannel.stop();
			soundChannel = null;
		}
	}
	
	private function resumeChannel() {
		if (soundChannel == null) {
			if (sound == null) {
				sound = new Sound();
				sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sineWaveGenerator);
			}
			soundChannel = sound.play();
		}
	}

	public function setVelocity(set:Bool, velocity:Float):Void {
		this.velocity = velocity;
		if (velocity != 0) {
			resumeChannel();
		} else {
			pauseChannel();
		}
		//var sound:Sound = new Sound();
	}
}
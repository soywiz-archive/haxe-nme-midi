package ;

import haxe.io.Bytes;
import haxe.Log;
import midi.Midi;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import native.utils.ByteArray;
import nme.media.Sound;
import nme.utils.Endian;
import sys.io.File;
import wildmidi.GusPatch;
import wildmidi.Sample;

/**
 * ...
 * @author soywiz
 */

class Main extends Sprite 
{
	
	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	private function init(e) 
	{
		var sample:Sample = GusPatch.load_gus_pat(ByteArray.fromBytes(File.getBytes("C:/temp/soundfonts/fluid-soundfont-lite-patches/FluidR3_GM-B0/Strings.pat")), "", false);
		Log.trace(sample.data.length);
		var sound:Sound = new Sound();
		sound.loadPCMFromByteArray(sample.data, sample.data.length >> 1, "short", false, 44100);
		sound.play();
		
		/*
		var player:midi.player.MidiPlayer = new midi.player.MidiPlayer(
			Midi.fromByteArray(ByteArray.fromBytes(
				//File.getBytes("C:/projects/SECRET.MID")
				File.getBytes("C:/projects/aaa.MID")
			))
		);
		player.play();
		*/
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}

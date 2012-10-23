package ;

import haxe.io.Bytes;
import haxe.Log;
import midi.Midi;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import neash.utils.ByteArray;
import nme.utils.Endian;
import sys.io.File;

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
		var player:midi.player.MidiPlayer = new midi.player.MidiPlayer(
			Midi.fromByteArray(ByteArray.fromBytes(
				//File.getBytes("C:/projects/SECRET.MID")
				File.getBytes("C:/projects/aaa.MID")
			))
		);
		player.play();
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}

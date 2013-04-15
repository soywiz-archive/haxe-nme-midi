package wildmidi;
import haxe.Log;
import nme.errors.Error;
import nme.events.SampleDataEvent;
import nme.utils.ByteArray;
import nme.utils.Endian;

//typedef UByte = Int;
//typedef UShort = Int;
//typedef SShort = Int;

/**
 * ...
 * @author ...
 */
class GusPatch
{
	static public var WM_SampleRate:Float = 41100.0;
	
	static public function load_gus_pat(gus_patch:ByteArray, filename:String, fix_release:Bool):Sample
	{
		var gus_size = gus_patch.length;
		var gus_ptr:Int;
		var no_of_samples:Int;
		var gus_sample:Sample = null;
		var first_gus_sample:Sample = null;
		var i:Int = 0;

		/*
		int (*do_convert[])(unsigned char *data, struct _sample *gus_sample ) = {
			convert_8s,
			convert_16s,
			convert_8u,
			convert_16u,
			convert_8sp,
			convert_16sp,
			convert_8up,
			convert_16up,
			convert_8sr,
			convert_16sr,
			convert_8ur,
			convert_16ur,
			convert_8srp,
			convert_16srp,
			convert_8urp,
			convert_16urp
		};
		*/
		var tmp_loop:Int;

		//SAMPLE_CONVERT_DEBUG(__FUNCTION__);
		//SAMPLE_CONVERT_DEBUG(filename);
        //
		//if ((gus_patch = WM_BufferFile(filename,&gus_size)) == NULL) {
		//	return NULL;
		//}
		if (gus_size < 239) throw(new Error("(too short)"));
		gus_patch.position = 0;
		var magicString1:String = gus_patch.readMultiByte(11, "ISO-8859-1");
		gus_patch.position = 12;
		var magicString2:String = gus_patch.readMultiByte(9, "ISO-8859-1");
		if (magicString1 != "GF1PATCH100" && magicString1 != "GF1PATCH110") throw(new Error("(unsupported format) : magic2"));
		if (magicString2 != "ID#000002") throw(new Error("(unsupported format) : magic2"));
		if (gus_patch[82] > 1) throw(new Error("(unsupported format) : 82"));
		if (gus_patch[151] > 1) throw(new Error("(unsupported format) : 151"));

		//GUSPAT_FILENAME_DEBUG(filename);
		//GUSPAT_INT_DEBUG("voices",gus_patch[83]);

		no_of_samples = gus_patch[198];
		gus_ptr = 239;
		for (current_sample in 0 ... no_of_samples)
		{
			var tmp_cnt:Int;
			if (first_gus_sample == null) {
				first_gus_sample = new Sample();
				gus_sample = first_gus_sample;
			} else {
				gus_sample.next = new Sample();
				gus_sample = gus_sample.next;
			}
			if (gus_sample == null) throw(new Error("gus_sample == null"));

			gus_sample.next = null;
			gus_sample.loop_fraction = gus_patch[gus_ptr+7];
			gus_sample.data_length = (gus_patch[gus_ptr+11] << 24) | (gus_patch[gus_ptr+10] << 16) | (gus_patch[gus_ptr+9] << 8) | gus_patch[gus_ptr+8];
			gus_sample.loop_start = (gus_patch[gus_ptr+15] << 24) | (gus_patch[gus_ptr+14] << 16) | (gus_patch[gus_ptr+13] << 8) | gus_patch[gus_ptr+12];
			gus_sample.loop_end = (gus_patch[gus_ptr+19] << 24) | (gus_patch[gus_ptr+18] << 16) | (gus_patch[gus_ptr+17] << 8) | gus_patch[gus_ptr+16];
			gus_sample.rate = (gus_patch[gus_ptr+21] << 8) | gus_patch[gus_ptr+20];
			gus_sample.freq_low = ((gus_patch[gus_ptr+25] << 24) | (gus_patch[gus_ptr+24] << 16) | (gus_patch[gus_ptr+23] << 8) | gus_patch[gus_ptr+22]);
			gus_sample.freq_high = ((gus_patch[gus_ptr+29] << 24) | (gus_patch[gus_ptr+28] << 16) | (gus_patch[gus_ptr+27] << 8) | gus_patch[gus_ptr+26]);
			gus_sample.freq_root = ((gus_patch[gus_ptr+33] << 24) | (gus_patch[gus_ptr+32] << 16) | (gus_patch[gus_ptr+31] << 8) | gus_patch[gus_ptr+30]);

			// This is done this way instead of ((freq * 1024) / rate) to avoid 32bit overflow.
			// Result is 0.001% inacurate
			gus_sample.inc_div = Std.int(((gus_sample.freq_root * 512) / gus_sample.rate) * 2);

			// We dont use this info at this time ... kept in here for info
			//printf("\rTremolo Sweep: %i, Rate: %i, Depth %i\n", gus_patch[gus_ptr+49], gus_patch[gus_ptr+50], gus_patch[gus_ptr+51]);
			//printf("\rVibrato Sweep: %i, Rate: %i, Depth %i\n", gus_patch[gus_ptr+52], gus_patch[gus_ptr+53], gus_patch[gus_ptr+54]);
			gus_sample.modes = gus_patch[gus_ptr + 55];
			
			//GUSPAT_START_DEBUG();
			//GUSPAT_MODE_DEBUG(gus_patch[gus_ptr+55], SAMPLE_16BIT, "16bit ");
			//GUSPAT_MODE_DEBUG(gus_patch[gus_ptr+55], SAMPLE_UNSIGNED, "Unsigned ");
			//GUSPAT_MODE_DEBUG(gus_patch[gus_ptr+55], SAMPLE_LOOP, "Loop ");
			//GUSPAT_MODE_DEBUG(gus_patch[gus_ptr+55], SAMPLE_PINGPONG, "PingPong ");
			//GUSPAT_MODE_DEBUG(gus_patch[gus_ptr+55], SAMPLE_REVERSE, "Reverse ");
			//GUSPAT_MODE_DEBUG(gus_patch[gus_ptr+55], SAMPLE_SUSTAIN, "Sustain ");
			//GUSPAT_MODE_DEBUG(gus_patch[gus_ptr+55], SAMPLE_ENVELOPE, "Envelope ");
			//GUSPAT_MODE_DEBUG(gus_patch[gus_ptr+55], SAMPLE_CLAMPED, "Clamped ");
			//GUSPAT_END_DEBUG();

			if (gus_sample.loop_start > gus_sample.loop_end) {
				tmp_loop = gus_sample.loop_end;
				gus_sample.loop_end = gus_sample.loop_start;
				gus_sample.loop_start = tmp_loop;
				gus_sample.loop_fraction  = ((gus_sample.loop_fraction & 0x0f) << 4) | ((gus_sample.loop_fraction & 0xf0) >> 4);
			}


			//FIXME: Experimental Hacky Fix

			if (fix_release) {
				if (Constants.env_time_table[gus_patch[gus_ptr+40]] < Constants.env_time_table[gus_patch[gus_ptr+41]]) {
					var tmp_hack_rate:Int = gus_patch[gus_ptr+41];
					gus_patch[gus_ptr+41] = gus_patch[gus_ptr+40];
					gus_patch[gus_ptr+40] = tmp_hack_rate;
				}
			}

			for (i in 0 ... 6) {
				if ((gus_sample.modes & Constants.SAMPLE_ENVELOPE) != 0) {
					var env_rate:Int = gus_patch[gus_ptr+37+i];
					gus_sample.env_target[i] = 16448 * gus_patch[gus_ptr+43+i];
					//GUSPAT_INT_DEBUG("Envelope Level",gus_patch[gus_ptr+43+i]);
					//GUSPAT_FLOAT_DEBUG("Envelope Time",Constants.env_time_table[env_rate]);
					gus_sample.env_rate[i]  = Math.floor(4194303.0 / (WM_SampleRate * Constants.env_time_table[env_rate]));

					if (gus_sample.env_rate[i] == 0) {
						//Log.trace(Std.format("\rWarning: libWildMidi %s found invalid envelope(%lu) rate setting in %s. Using %f instead.\n", __FUNCTION__, i, filename, env_time_table[63]));
						gus_sample.env_rate[i]  = Math.floor(4194303.0 / (WM_SampleRate * Constants.env_time_table[63]));
						//GUSPAT_FLOAT_DEBUG("Envelope Time",Constants.env_time_table[63]);
					}
				} else {
					gus_sample.env_target[i] = 4194303;
					gus_sample.env_rate[i]  = Math.floor(4194303.0 / (WM_SampleRate * Constants.env_time_table[63]));
					//GUSPAT_FLOAT_DEBUG("Envelope Time",Constants.env_time_table[63]);
				}
			}

			gus_sample.env_target[6] = 0;
			gus_sample.env_rate[6]  = Math.floor(4194303.0 / (WM_SampleRate * Constants.env_time_table[63]));

			gus_ptr += 96;
			tmp_cnt = gus_sample.data_length;

			var bits:Int = ((gus_sample.modes & 1) == 0) ? 8 : 16;
			var signed:Bool = ((gus_sample.modes & 2) == 0);
			var pingPong:Bool = ((gus_sample.modes & 4) == 0);
			var reverse:Bool = ((gus_sample.modes & 8) == 0);
			
			do_convert(gus_patch, gus_ptr, gus_sample, bits, signed, pingPong, reverse);

			gus_ptr += tmp_cnt;
			gus_sample.loop_start = (gus_sample.loop_start << 10) | Std.int(((gus_sample.loop_fraction & 0x0f) << 10) / 16);
			gus_sample.loop_end = (gus_sample.loop_end << 10) | Std.int(((gus_sample.loop_fraction & 0xf0) << 6) / 16);
			gus_sample.loop_size = gus_sample.loop_end - gus_sample.loop_start;
			gus_sample.data_length = gus_sample.data_length << 10;
		}
		return first_gus_sample;
	}

	static private function do_convert(gus_patch:ByteArray, gus_ptr:Int, gus_sample:Sample, bits:Int, signed:Bool, pingPong:Bool, reverse:Bool):Void
	{
		//Log.trace(bits + "," + signed + "," + pingPong + "," + reverse);
		var buffer:ByteArray = new ByteArray();
		buffer.endian = reverse ? Endian.BIG_ENDIAN : Endian.LITTLE_ENDIAN;
		gus_patch.position = gus_ptr;
		gus_patch.readBytes(buffer);
		buffer.position = 0;
		gus_sample.data = new ByteArray();
		while (buffer.bytesAvailable > 0) {
			var value:Int = 0;
			if (signed) {
				if (bits == 8) value = buffer.readByte() << 8; else value = buffer.readShort();
			} else {
				if (bits == 8) value = buffer.readUnsignedByte() << 8; else value = buffer.readUnsignedShort();
				value -= 0x7FFF;
			}
			gus_sample.data.writeShort(value & 0xFFFF);
		}
		gus_sample.data.position = 0;
	}
}
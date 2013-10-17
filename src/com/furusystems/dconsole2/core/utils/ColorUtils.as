package com.furusystems.dconsole2.core.utils {
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ColorUtils {
		public static function gainColor24(input:uint, gain:int):uint {
			return clamp24(input + 0x010101 * gain, 0xFFFFFF);
		}
		
		public static function clamp24(input:uint, maxValue:uint):uint {
			return Math.max(0, Math.min(input, maxValue));
		}
	
	}

}
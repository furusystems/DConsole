package com.furusystems.dconsole2.core.utils {
	
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	public class ArgumentCleaner {
		
		public static function cleanObjectName(s:String):String {
			if (s.indexOf("[object ") > -1) {
				return s.split("[object ").join("").split("]").join("");
			}
			if (s.indexOf("[class ") > -1) {
				return s.split("[class ").join("").split("]").join("");
			}
			return s;
		}
	
	}

}
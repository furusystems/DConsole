package com.furusystems.dconsole2.core.utils {
	
	/**
	 * String Util
	 *
	 * @author Andreas Roenning, Cristobal Dabed
	 */
	public final class StringUtil {
		public function StringUtil() {
		}
		
		public static function verboseToBoolean(input:String):Boolean {
			input = input.toLowerCase();
			switch (input) {
				case "on":
				case "yes":
				case "true":
				case "1":
					return true;
				case "off":
				case "no":
				case "false":
				case "0":
				default:
					return false;
			}
		}
		
		public static function stripWhitespace(str:String):String {
			while (str.charAt(str.length - 1) == " ") {
				str = str.substr(0, str.length - 1);
			}
			return str;
		}
		
		/**
		 * Trim
		 *
		 * @param value The string value to trim.
		 */
		public static function trim(value:String):String {
			return rtrim(ltrim(value));
		}
		
		/**
		 * Right trim
		 *
		 * @param value The string value to trim the whitespace from right.
		 */
		public static function rtrim(value:String):String {
			while (value.charAt(value.length - 1) == " ") {
				value = value.substr(0, value.length - 1);
			}
			return value;
		}
		
		/**
		 * Left trim
		 *
		 * @param value The string value to trim whitespace from left.
		 */
		public static function ltrim(value:String):String {
			while (value.charAt(0) == " ") {
				value = value.substr(1);
			}
			return value;
		}
		
		/**
		 * Trim \s|\t|\n over multilines
		 *
		 * @param value The string value to trim.
		 */
		public static function multiTrim(value:String):String {
			return rtrim(value.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2"));
		}
		
		/**
		 * Ucfirst
		 *
		 * @param value The string to convert to upper case.
		 */
		public static function ucfirst(value:String):String {
			return (value.charAt(0).toUpperCase() + value.toLowerCase().substr(1));
		}
		
		/**
		 * ReplaceAll
		 *
		 * @param search
		 * @param replacement
		 * @param
		 */
		public static function replaceAll(search:String, replacement:String, value:String):String {
			if (value) {
				value = value.split(search).join(replacement);
			}
			return value;
		}
		
		/**
		 * Equals ignore case
		 *
		 * @param a
		 * @param b
		 *
		 * @return
		 * 	Returns true or fals depending on wether the strings matches ignoring case.
		 */
		public static function equalsIgnoreCase(a:String, b:String):Boolean {
			return a.toLowerCase() == b.toLowerCase();
		}
		
		/**
		 * Pad number
		 *
		 * @param n 	The number
		 * @param pad	The padding defaults to 2
		 */
		public static function padNumber(n:Object, pad:int = 2):String {
			var value:String = String(n);
			while (value.length < pad) {
				value = "0" + value;
			}
			return value;
		}
		//*
		//* Returns a formatted string using the specified format string and arguments.
		//*
		//* @see http://download-llnw.oracle.com/javase/6/docs/api/java/lang/String.html#format(java.lang.String,%20java.lang.Object...)
		//* @see http://github.com/mstandio/SaladoPlayer/blob/76afec9d6764c5b45418e52c6005c7fea2f82c1a/src/performance/profiler/sprintf.as
		//* @see http://popforge.googlecode.com/svn/trunk/flash/PopforgeLibrary/src/de/popforge/utils/sprintf.as
		//*
		//* @param format 	A format string
		//* @param args 		Arguments referenced by the format specifiers in the format string. If there are more arguments than format specifiers, the extra arguments are ignored.
		//*
		//* @return
		//* 		A formatted string
		//*/
		//public static function format(format:String, ...args):String
		//{
		// TODO: Repass the sprintf function at a later point
		// At the moment we use the underlying sprintf function from popforge
		//args.unshift(format);
		//return sprintf.apply(sprintf, args);
		//}
	}
}
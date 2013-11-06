package com.furusystems.dconsole2.core.text {
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class TextUtils {
		public function TextUtils() {
		
		}
		
		public static function getNextSpaceAfterCaret(tf:TextField):int {
			var str:String = tf.text;
			var first:int = str.lastIndexOf(" ", tf.caretIndex) + 1;
			var last:int = str.indexOf(" ", first);
			if (last < 0)
				last = tf.text.length;
			return last;
		}
		
		public static function selectWordAtCaretIndex(tf:TextField):void {
			var str:String = tf.text;
			var first:int = str.lastIndexOf(" ", tf.caretIndex) + 1;
			var last:int = str.indexOf(" ", first);
			if (last == -1)
				last = str.length;
			tf.setSelection(first, last);
		}
		
		public static function getWordAtCaretIndex(tf:TextField):String {
			return getWordAtIndex(tf, tf.caretIndex);
		}
		
		public static function getWordAtIndex(tf:TextField, index:int):String {
			if (tf.text.charAt(tf.caretIndex) == " ") {
				index--; //We want the word behind the current space, not the next one
			}
			var str:String = tf.text;
			var li:int = str.lastIndexOf(" ", index);
			var first:int = li + 1;
			var last:int = str.indexOf(" ", first);
			if (last == -1) {
				last = str.length;
			}
			return str.slice(first, last);
		}
		
		public static function getFirstIndexOfWordAtCaretIndex(tf:TextField):int {
			var wordAtIndex:String = getWordAtCaretIndex(tf);
			var str:String = tf.text;
			return str.lastIndexOf(wordAtIndex, tf.caretIndex);
		}
		
		public static function getLastIndexOfWordAtCaretIndex(tf:TextField):int {
			var wordAtIndex:String = getWordAtCaretIndex(tf);
			var str:String = tf.text;
			return str.indexOf(wordAtIndex, tf.caretIndex) + wordAtIndex.length;
		}
		
		public static function getCaretDepthOfWord(tf:TextField):int {
			//var word:String = getWordAtCaretIndex(tf);
			var wordIndex:int = getFirstIndexOfWordAtCaretIndex(tf);
			return tf.caretIndex - wordIndex;
		}
		
		public static function stripWhitespace(str:String):String {
			while (str.charAt(str.length - 1) == " ") {
				str = str.substr(0, str.length - 1);
			}
			return str;
		}
		
		public static function parseForSecondElement(str:String):String {
			var split:Array = str.split(" ");
			if (split.length > 1) {
				return split[1];
			}
			return "";
		}
		
		/**
		 * Trim
		 *	- http://blog.stevenlevithan.com/archives/faster-trim-javascript
		 *
		 * @param str 	The string to trim.
		 *
		 * @return
		 * 	Returns the trimmed str value with whitespace removed at the start and end of the string.
		 */
		public static function trim(str:String):String {
			str = str.replace(/^\s\s*/, '');
			var ws:RegExp = /\s/, i:int = str.length;
			while (ws.test(str.charAt(--i))) {
			}
			;
			return str.slice(0, i + 1);
		}
	
	}

}
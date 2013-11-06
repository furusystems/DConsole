package com.furusystems.dconsole2.core.commands.utils {
	import com.furusystems.dconsole2.core.errors.ErrorStrings;
	
	/**
	 * Utility for splitting strings into argument objects
	 * @author Andreas Roenning
	 */
	public class ArgumentSplitterUtil {
		private static const SINGLE_QUOTE:int = "'".charCodeAt(0);
		private static const DOUBLE_QUOTE:int = '"'.charCodeAt(0);
		private static const OBJECT_START:int = "{".charCodeAt(0);
		private static const OBJECT_STOP:int = "}".charCodeAt(0);
		private static const ARRAY_START:int = "[".charCodeAt(0);
		private static const ARRAY_STOP:int = "]".charCodeAt(0);
		private static const SUBCOMMAND_START:int = "(".charCodeAt(0);
		private static const SUBCOMMAND_STOP:int = ")".charCodeAt(0);
		private static const SPACE:int = " ".charCodeAt(0);
		private static const UTIL:int = "|".charCodeAt(0);
		
		public static function slice(a:String):Array {
			//fast search for string input
			if ((a.charAt(0) == "'" && a.charAt(a.length - 1) == "'") || (a.charAt(0) == '"' && a.charAt(a.length - 1) == '"')) {
				return [a];
			}
			var position:int = 0;
			
			while (position < a.length) {
				position++;
				var char:int = a.charCodeAt(position);
				switch (char) {
					case SUBCOMMAND_START:
						position = findSubCommand(a, position);
						break;
					case SPACE:
						var sa:String = a.substring(0, position);
						var sb:String = a.substring(position + 1);
						var ar:Array = [sa, sb];
						a = ar.join(UTIL);
						break;
					case SINGLE_QUOTE:
					case DOUBLE_QUOTE:
						position = findString(a, position);
						break;
					case OBJECT_START:
						position = findObject(a, position);
						break;
					case ARRAY_START:
						position = findArray(a, position);
						break;
				}
			}
			var out:Array = a.split(UTIL);
			var str:String = "";
			for (var i:int = 0; i < out.length; i++) {
				str = out[i];
				if (str.charCodeAt(0) == SINGLE_QUOTE || str.charCodeAt(0) == DOUBLE_QUOTE) {
					out[i] = str.substring(1, str.length - 1);
				}
			}
			return out;
		}
		
		private static function findSubCommand(input:String, start:int):int {
			var score:int = 0;
			var l:int = input.length;
			var char:int;
			var end:int;
			for (var i:int = start; i < l; i++) {
				char = input.charCodeAt(i);
				if (char == SUBCOMMAND_START) {
					score++;
				} else if (char == SUBCOMMAND_STOP) {
					score--;
					if (score <= 0) {
						end = i;
						break;
					}
				}
			}
			if (score > 0) {
				throw(new ArgumentError(ErrorStrings.SUBCOMMAND_PARSE_ERROR_TERMINATION));
			}
			return end;
		}
		
		private static function findObject(input:String, start:int):int {
			var score:int = 0;
			var l:int = input.length;
			var char:int;
			var end:int;
			for (var i:int = start; i < l; i++) {
				char = input.charCodeAt(i);
				if (char == OBJECT_START) {
					score++;
				} else if (char == OBJECT_STOP) {
					score--;
					if (score <= 0) {
						end = i;
						break;
					}
				}
			}
			if (score > 0) {
				throw(new ArgumentError(ErrorStrings.OBJECT_PARSE_ERROR_TERMINATION));
			}
			return end;
		}
		
		private static function findArray(input:String, start:int):int {
			var score:int = 0;
			var l:int = input.length;
			var char:int;
			var end:int;
			for (var i:int = start; i < l; i++) {
				char = input.charCodeAt(i);
				if (char == ARRAY_START) {
					score++;
				} else if (char == ARRAY_STOP) {
					score--;
					if (score <= 0) {
						end = i;
						break;
					}
				}
			}
			if (score > 0) {
				throw(new ArgumentError(ErrorStrings.ARRAY_PARSE_ERROR_TERMINATION));
			}
			return end;
		}
		
		private static function findString(input:String, start:int):int {
			var out:int = input.indexOf(input.charAt(start), start + 1);
			if (out < start)
				throw(new ArgumentError(ErrorStrings.STRING_PARSE_ERROR_TERMINATION));
			return out;
		}
		
		private static function findCommand(input:String):int {
			return input.split(SPACE).shift().length;
		}
	
	}

}
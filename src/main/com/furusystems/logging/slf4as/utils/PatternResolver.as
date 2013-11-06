package com.furusystems.logging.slf4as.utils {
	import com.furusystems.logging.slf4as.constants.PatternTypes;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class PatternResolver {
		static private var SLF_DELIMITER:String = "{}";
		static public var LOOP_PATTERN:Boolean = true;
		
		static public function resolve(patternType:int, args:Array):String {
			switch (patternType) {
				//case PatternTypes.PRINT_F:
				//return args + ""; //TODO: Sprintf..?
				case PatternTypes.SLF:
					if (("" + args[0]).indexOf("{}") > -1) { //TODO: This string concatenation has to go
						return resolveSLF(args);
					} else {
						return args.join(" ");
					}
				case PatternTypes.NONE:
				default:
					return args.join(" ");
			}
		}
		
		static private function resolveSLF(args:Array):String {
			if (args.length < 2) {
				return args.join(" ");
			}
			var pat:String = args.shift();
			
			var tail:String = "";
			var split:Array = pat.split(SLF_DELIMITER);
			if (split[split.length - 1] == "") {
				split.pop();
			} else {
				tail = split.pop();
			}
			var out:Array = [];
			var counter:int = 0;
			while (args.length > 0) {
				var arg:String = "" + args.shift();
				out.push(split[counter] + arg);
				counter++;
				if (counter > split.length - 1) {
					out.push(tail);
					if (!LOOP_PATTERN)
						break;
					if (args.length > 0) {
						out.push(", "); //looping back over pattern
					}
					counter = 0;
				}
			}
			return out.join("");
		}
	
	}

}
package com.furusystems.logging.slf4as.utils {
	import com.furusystems.logging.slf4as.constants.Levels;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class LevelInfo {
		public static function getID(level:String):int {
			var u:String = level.toUpperCase();
			if (Levels[u]) {
				return Levels[u];
			}
			return Levels.DEBUG;
		}
		
		public static function getName(id:int):String {
			switch (id) {
				case 0:
					return "ALL";
				case 1:
					return "DEBUG";
				case 2:
					return "INFO";
				case 3:
					return "WARN";
				case 4:
					return "ERROR";
				case 5:
					return "FATAL";
				case 6:
				default:
					return "NONE";
			}
		}
	}

}
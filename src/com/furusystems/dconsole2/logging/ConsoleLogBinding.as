package com.furusystems.dconsole2.logging {
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.logging.slf4as.bindings.ILogBinding;
	import com.furusystems.logging.slf4as.constants.Levels;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.logging.slf4as.utils.LevelInfo;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ConsoleLogBinding implements ILogBinding {
		
		public function ConsoleLogBinding() {
			DConsole.createCommand("setLoggingLevel", setLoggingLevel, "Logging", "Set the current logging level (ERROR,FATAL,INFO,WARN,DEBUG)");
			DConsole.createCommand("getLoggingLevel", getLoggingLevel, "Logging", "Print the current logging level");
		}
		
		private function getLoggingLevel():void {
			DConsole.addSystemMessage("Current logging level is '" + LevelInfo.getName(Logging.getLevel()) + "'");
		}
		
		private function setLoggingLevel(level:String = "ALL"):void {
			
			Logging.setLevel(LevelInfo.getID(level));
			getLoggingLevel();
		}
		
		/* INTERFACE com.furusystems.logging.slf4as.bindings.ILogBinding */
		
		public function print(owner:Object, level:String, str:String):void {
			if (String(owner) == "Logging")
				owner = DConsole.TAG;
			var l:String = ConsoleMessageTypes.DEBUG;
			switch (LevelInfo.getID(level)) {
				case Levels.ERROR:
					l = ConsoleMessageTypes.ERROR;
					break;
				case Levels.FATAL:
					l = ConsoleMessageTypes.FATAL;
					break;
				case Levels.INFO:
					l = ConsoleMessageTypes.INFO;
					break;
				case Levels.WARN:
					l = ConsoleMessageTypes.WARNING;
					break;
				case Levels.DEBUG:
				default:
					l = ConsoleMessageTypes.DEBUG;
					break;
			}
			DConsole.print(str, l, String(owner));
		}
	
	}

}
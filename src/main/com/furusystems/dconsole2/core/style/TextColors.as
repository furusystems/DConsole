package com.furusystems.dconsole2.core.style {
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class TextColors {
		public static var TEXT_USER:uint = 0x859900;
		public static var TEXT_SYSTEM:uint = 0x859900;
		public static var TEXT_DEBUG:uint = 0x859900;
		public static var TEXT_INFO:uint = 0x859900;
		public static var TEXT_WARNING:uint = 0x859900;
		public static var TEXT_ERROR:uint = 0x859900;
		public static var TEXT_FATAL:uint = 0x859900;
		public static var TEXT_AUX:uint = 0x859900;
		
		public static var TEXT_ASSISTANT:uint = 0x859900;
		public static var TEXT_INPUT:uint = 0x859900;
		public static var TEXT_TAG:uint = 0;
		
		public static function update(sm:StyleManager):void {
			TEXT_USER = sm.theme.data.output.text.user;
			TEXT_SYSTEM = sm.theme.data.output.text.system;
			TEXT_DEBUG = sm.theme.data.output.text.debug;
			TEXT_INFO = sm.theme.data.output.text.info;
			TEXT_WARNING = sm.theme.data.output.text.warning;
			TEXT_ERROR = sm.theme.data.output.text.error;
			TEXT_FATAL = sm.theme.data.output.text.fatal;
			TEXT_AUX = sm.theme.data.output.text.aux;
			TEXT_TAG = sm.theme.data.output.text.tag;
			
			TEXT_ASSISTANT = sm.theme.data.assistant.fore;
			TEXT_INPUT = sm.theme.data.input.fore;
		}
	
	}

}
package com.furusystems.dconsole2.core.output {
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public final class ConsoleMessage {
		public var applicationTimeMS:int = 0;
		public var timestamp:String = "";
		public var text:String = "";
		public var repeatcount:int = 0;
		public var type:String;
		public var tag:String;
		public var truncated:Boolean = false;
		public var visible:Boolean = true;
		
		public function ConsoleMessage(text:String, timestamp:String, type:String = "Info", tag:String = "") {
			this.tag = tag;
			this.text = text;
			this.timestamp = timestamp;
			this.type = type;
			applicationTimeMS = getTimer();
		}
		
		public function toString():String {
			var out:String = type+":\t";
			out += text;
			return out;
		}
	
	}

}
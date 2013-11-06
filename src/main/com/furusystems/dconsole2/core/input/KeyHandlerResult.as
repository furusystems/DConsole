package com.furusystems.dconsole2.core.input {
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public final class KeyHandlerResult {
		
		public function reset():void {
			swallowEvent = false;
			autoCompleted = false;
		}
		public var swallowEvent:Boolean = false;
		public var autoCompleted:Boolean = false;
	
	}

}
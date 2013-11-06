package com.furusystems.dconsole2.core.errors {
	
	/**
	 * Error type used when prohibited access is attempted
	 * @author Andreas Roenning
	 */
	public class ConsoleAuthError extends Error {
		
		public function ConsoleAuthError(message:String = "Not authenticated", id:int = 0) {
			super(message, id);
		}
	
	}

}
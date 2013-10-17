package com.furusystems.dconsole2.core.errors {
	
	/**
	 * Error type used when commands result in errors
	 * @author Andreas Roenning
	 */
	public class CommandError extends Error {
		
		public function CommandError(msg:String) {
			super(msg);
		}
	
	}

}
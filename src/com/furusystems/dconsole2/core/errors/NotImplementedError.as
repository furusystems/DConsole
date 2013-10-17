package com.furusystems.dconsole2.core.errors {
	
	/**
	 * Generic error used with abstract function definitions
	 * @author Andreas Roenning
	 */
	public class NotImplementedError extends Error {
		
		public function NotImplementedError(message:String = "Not implemented", id:int = 0) {
			super(message, id);
		}
	
	}

}
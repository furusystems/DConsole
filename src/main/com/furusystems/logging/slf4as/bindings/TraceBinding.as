package com.furusystems.logging.slf4as.bindings {
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class TraceBinding implements ILogBinding {
		/* INTERFACE com.furusystems.logging.slf4as.bindings.ILogBinding */
		
		private static var _lineNumber:int = 0;
		
		public function print(owner:Object, level:String, str:String):void {
			trace((_lineNumber++) + "\t" + level + "\t" + owner + "\t" + str);
		}
	
	}

}
package com.furusystems.logging.slf4as.bindings {
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public interface ILogBinding {
		function print(owner:Object, level:String, str:String):void;
	}

}
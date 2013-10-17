package com.furusystems.logging.slf4as.global {
	import com.furusystems.logging.slf4as.Logging;
	
	public function debug(... args:Array):void {
		Logging.root.debug.apply(null, args);
	}
}
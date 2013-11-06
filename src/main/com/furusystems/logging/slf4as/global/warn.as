package com.furusystems.logging.slf4as.global {
	import com.furusystems.logging.slf4as.Logging;
	
	public function warn(... args:Array):void {
		Logging.root.warn.apply(null, args);
	}
}
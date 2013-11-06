package com.furusystems.logging.slf4as.global {
	import com.furusystems.logging.slf4as.Logging;
	
	public function info(... args:Array):void {
		Logging.root.info.apply(null, args);
	}
}
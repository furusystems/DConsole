package com.furusystems.logging.slf4as.global {
	
	import com.furusystems.logging.slf4as.Logging;
	
	public function log(level:String, ... args:Array):void {
		Logging.root.log.apply(null, [level].concat(args));
	}
}
package com.furusystems.logging.slf4as {
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public interface ILogger {
		function info(... args:Array):void;
		function debug(... args:Array):void;
		function error(... args:Array):void;
		function warn(... args:Array):void;
		function fatal(... args:Array):void;
		function log(level:int, ... args:Array):void;
		function setPatternType(type:int):void;
		function getPatternType():int;
		
		function get enabled():Boolean;
		function set enabled(b:Boolean):void;
	}

}
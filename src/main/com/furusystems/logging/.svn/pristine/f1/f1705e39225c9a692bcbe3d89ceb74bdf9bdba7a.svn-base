package com.furusystems.logging.slf4as.loggers 
{
	import com.furusystems.logging.slf4as.constants.Levels;
	import com.furusystems.logging.slf4as.constants.PatternTypes;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.logging.slf4as.utils.LevelInfo;
	import com.furusystems.logging.slf4as.utils.PatternResolver;
	import com.furusystems.logging.slf4as.utils.TagCreator;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class Logger implements ILogger
	{
		private var _owner:Class;
		private var _tag:String;
		private var _patternType:int = PatternTypes.NONE;
		private var _inheritPattern:Boolean = true;
		private var _useAppName:Boolean = false;
		private var _enabled:Boolean = true;
		public function Logger(owner:*) 
		{
			_owner = owner;
			if (_owner == Logging && Logging.getDefaultLoggerTag() != Logging.DEFAULT_APP_NAME) { 
				_useAppName = true;
			}else {
				_tag = TagCreator.getTag(owner);
			}
		}
		
		/* INTERFACE com.furusystems.logging.slf4as.ILogger */
		
		public function info(...args:Array):void 
		{
			log.apply(this, [Levels.INFO].concat(args));
		}
		
		public function debug(...args:Array):void 
		{
			log.apply(this, [Levels.DEBUG].concat(args));
		}
		
		public function error(...args:Array):void 
		{
			log.apply(this, [Levels.ERROR].concat(args));
		}
		
		public function warn(...args:Array):void 
		{
			log.apply(this, [Levels.WARN].concat(args));
		}
		
		public function fatal(...args:Array):void 
		{
			log.apply(this, [Levels.FATAL].concat(args));
		}
		
		public function log(level:int, ...args:Array):void 
		{
			if (Logging.getLevel() > level || !_enabled) return;
			var time:Number = getTimer();
			var levelStr:String = LevelInfo.getName(level);
			var out:String = PatternResolver.resolve(getPatternType(), args);
			Logging.print(getTag(), levelStr, out);
		}
		private function getTag():String {
			if (_useAppName) {
				return Logging.getDefaultLoggerTag();
			}
			return _tag;
		}
		
		public function setPatternType(type:int):void 
		{
			_patternType = type;
			_inheritPattern = false;
		}
		
		public function getPatternType():int 
		{
			if (_inheritPattern) {
				return Logging.getPatternType();
			}
			return _patternType;
		}
		
		/* INTERFACE com.furusystems.logging.slf4as.ILogger */
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		
	}

}
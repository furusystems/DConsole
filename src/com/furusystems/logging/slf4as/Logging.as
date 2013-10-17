package com.furusystems.logging.slf4as {
	import com.furusystems.logging.slf4as.bindings.ILogBinding;
	import com.furusystems.logging.slf4as.bindings.TraceBinding;
	import com.furusystems.logging.slf4as.constants.Levels;
	import com.furusystems.logging.slf4as.constants.PatternTypes;
	import com.furusystems.logging.slf4as.loggers.Logger;
	import com.furusystems.logging.slf4as.utils.TagCreator;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class Logging {
		public static const DEFAULT_APP_NAME:String = "Log";
		
		private static var _root:ILogger;
		private static var _logBinding:ILogBinding = new TraceBinding();
		
		private static var _patternType:int = PatternTypes.SLF;
		private static var _appName:String = "Log";
		private static var _minLevel:int = Levels.ALL;
		private static var _whitelist:Dictionary;
		private static var _blankWhiteList:Boolean = true;
		
		private static var _nativeTrace:Boolean = false;
		private static var _traceLineNumber:int = 0;
		
		static public function get root():ILogger {
			if (!_root) {
				_root = new Logger(Logging);
			}
			return _root;
		}
		
		static public function get logBinding():ILogBinding {
			return _logBinding;
		}
		
		static public function set logBinding(binding:ILogBinding):void {
			_logBinding = binding;
		}
		
		static public function get useNativeTrace():Boolean {
			return _nativeTrace;
		}
		
		static public function set useNativeTrace(value:Boolean):void {
			_nativeTrace = value;
		}
		
		static public function print(owner:Object, level:String, str:String):void {
			if (_logBinding) {
				if (_blankWhiteList) {
					_logBinding.print(owner, level, str);
				} else {
					if (_whitelist[owner] != null) {
						_logBinding.print(owner, level, str);
					}
				}
			}
			if (_nativeTrace) {
				trace(owner + "\t[" + level + "]\t" + str);
			}
		}
		
		public static function setPatternType(type:int):void {
			_patternType = type;
		}
		
		public static function getPatternType():int {
			return _patternType;
		}
		
		static public function getDefaultLoggerTag():String {
			return _appName;
		}
		
		static public function setDefaultLoggerTag(name:String):void {
			_appName = name.split(" ").join("_");
		}
		
		public static function getLogger(owner:*):ILogger {
			return new Logger(owner);
		}
		
		static public function setLevel(minlevel:int):void {
			_minLevel = minlevel;
		}
		
		static public function getLevel():int {
			return _minLevel;
		}
		
		static public function whitelist(... owners:Array):void {
			_whitelist = new Dictionary();
			for (var i:int = owners.length; i--; ) {
				if (owners[i] is Class) {
					owners[i] = TagCreator.getTag(owners[i]);
				}
				_whitelist[owners[i]] = true;
			}
			_blankWhiteList = owners.length == 0;
		}
		
		public static function isWhitelisted(tag:String):Boolean {
			return _whitelist[tag] != null;
		}
	
	}

}
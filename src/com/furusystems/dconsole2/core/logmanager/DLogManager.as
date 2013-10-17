package com.furusystems.dconsole2.core.logmanager 
{
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class DLogManager
	{
		private var _logMap:Dictionary = new Dictionary(true);
		private var _activeFilters:Dictionary = new Dictionary();
		private var _currentLog:DConsoleLog;
		private var _rootLog:DConsoleLog;
		private var _filtersActive:int = 0;
		private var _logsActive:int = 0;
		private var _messaging:PimpCentral;
		private static const TAG:String = "DConsole";
		public function DLogManager(console:DConsole) 
		{
			_messaging = console.messaging;
			_rootLog = _currentLog = addLog(TAG);
			_messaging.addCallback(Notifications.LOG_BUTTON_CLICKED, onLogButtonClick);
		}
		
		private function onLogButtonClick(md:MessageData):void
		{
			setCurrentLog(md.data as String);
		}
		public function clearAll():void {
			for each(var log:DConsoleLog in _logMap)
			{
				log.clear();
			}
		}
		public function addMessage(msg:ConsoleMessage, log:DConsoleLog = null):void {
			if (!log) log = _currentLog;
			validateFilters(msg);
			log.addMessage(msg);
		}
		public function getLog(name:String, createIfNotFound:Boolean = true):DConsoleLog {
			if (_logMap[name.toLowerCase()] != null) { 
				var log:DConsoleLog = _logMap[name.toLowerCase()];
				return log;
			}
			if (createIfNotFound) {
				return addLog(name);
			}
			throw new ArgumentError("No such log '" + name + "'");
		}
		public function addLog(name:String):DConsoleLog {
			var log:DConsoleLog = new DConsoleLog(name, this);
			_logMap[name.toLowerCase()] = log;
			_logsActive++;
			_messaging.send(Notifications.NEW_LOG_CREATED, log, this);
			return log;
		}
		public function removeLog(name:String):DConsoleLog {
			if (_logMap[name.toLowerCase()]!=null) {
				var log:DConsoleLog = _logMap[name.toLowerCase()];
				log.destroy();
				delete(_logMap[name.toLowerCase()]);
				_logsActive--;
				_messaging.send(Notifications.LOG_DESTROYED, log, this);
				return log;
			}
			throw new ArgumentError("No such log: " + name);
		}
		public function setCurrentLog(name:String):DConsoleLog {
			if (_logMap[name.toLowerCase()] != null) {
				_currentLog = _logMap[name.toLowerCase()];
			}
			_messaging.send(Notifications.CURRENT_LOG_CHANGED, _currentLog, this);
			return _currentLog;
		}
		
		public function addFilter(filter:DLogFilter):void {
			_activeFilters[filter.id] = filter;
			_filtersActive++;
			doFilter();
		}
		public function removeFilter(filter:DLogFilter):void {
			delete(_activeFilters[filter.id]);
			_filtersActive--;
			doFilter();
		}
		
		public function clearFilters():void
		{
			_activeFilters = new Dictionary();
			_filtersActive = 0;
			doFilter();
		}
		
		private function doFilter():void
		{
			for each(var log:DConsoleLog in _logMap) {
				for each(var m:ConsoleMessage in log.messages) {
					validateFilters(m);
				}
				_messaging.send(Notifications.LOG_CHANGED, log, this);
			}
		}
		private function validateFilters(msg:ConsoleMessage):void {
			msg.visible = true;
			for each(var filter:DLogFilter in _activeFilters) {
				var v:Boolean = true;
				if(filter.term!=""){
					v = msg.text.toLowerCase().indexOf(filter.term.toLowerCase()) > -1;
				}
				if (filter.tag != "") {
					v = msg.tag.toLowerCase() == filter.tag.toLowerCase();
				}
				msg.visible = v;
			}
		}
		
		public function get currentLog():DConsoleLog { return _currentLog; }
		
		public function get filtersActive():int { return _filtersActive; }
		
		public function get rootLog():DConsoleLog { return _rootLog; }
		
		public function get logsActive():int { return _logsActive; }
		
		/**
		 * Searches the current log for a message containing the term and returns the message index
		 * @param	term
		 * @return
		 * the message index
		 */
		public function searchCurrentLog(term:String):int {
			for (var i:int = 0; i < currentLog.length; i++) 
			{
				if (currentLog.messages[i].text.toLowerCase().indexOf(term.toLowerCase()) > -1) {
					return i;
				}
			}
			return -1;
		}
		/**
		 * Searches all logs for a message containing the term, switches to that log and returns the message index
		 * @param	term
		 * @return
		 */
		/*public function searchLogs(term:String):int {
			for (var i:int = 0; i < logs.length; i++) 
			{
				var log:DConsoleLog = logs[i];
				for (var j:int = 0; j < log.length; j++) 
				{
					if (log.messages[j].text.toLowerCase().indexOf(term.toLowerCase()) > -1) {
						_currentLog = logs[i];
						return j;
					}
				}
			}
			return -1;
		}*/
		
		public function getLogNames():Vector.<String> {
			var vec:Vector.<String> = new Vector.<String>();
			for each(var l:DConsoleLog in _logMap) {
				if(l!=_rootLog)	vec.push(l.name);
			}
			vec.sort(sortStrings);
			vec.unshift(_rootLog.name);
			return vec;
		}
		private function sortStrings(a:String,b:String):int
		{
			if (a > b) return 1;
			if (a < b) return -1;
			return 0;
		}
		public function hasFilterForTag(tag:String):Boolean
		{
			return _activeFilters[tag] != null;
		}
		public function hasFilterForSearch(term:String):Boolean {
			return _activeFilters[term] != null;
		}
		public function hasFilter(filter:DLogFilter):Boolean {
			return _activeFilters[filter.id] != null;
		}
		
	}

}
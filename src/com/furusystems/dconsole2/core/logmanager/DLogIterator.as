package com.furusystems.dconsole2.core.logmanager {
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	public class DLogIterator {
		private var _log:DConsoleLog;
		private var _index:int;
		private var _vec:Vector.<ConsoleMessage> = new Vector.<ConsoleMessage>();
		
		public function DLogIterator(log:DConsoleLog) {
			_log = log;
			_index = -1;
			countVisibleItems();
		}
		
		private function countVisibleItems():void {
			for each (var m:ConsoleMessage in _log.messages) {
				if (m.visible) {
					_vec.push(m);
				}
			}
		}
		
		public function get length():int {
			return _vec.length;
		}
		
		public function hasNext():Boolean {
			return _index < length;
		}
		
		public function next():ConsoleMessage {
			_index++;
			return _log.messages[_index];
		}
		
		public function getFilteredVector():Vector.<ConsoleMessage> {
			return _vec;
		}
	
	}

}
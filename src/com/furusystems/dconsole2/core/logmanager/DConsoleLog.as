package com.furusystems.dconsole2.core.logmanager {
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	
	/**
	 * Encapsulates a vector of messages, grouped
	 * @author Andreas Roenning
	 */
	public class DConsoleLog {
		private var _messages:Vector.<ConsoleMessage> = new Vector.<ConsoleMessage>();
		private var _name:String;
		private var _dirty:Boolean = true;
		private var _manager:DLogManager;
		private var _destroyed:Boolean = false;
		private var _prevMessage:ConsoleMessage = null;
		
		public function DConsoleLog(name:String, manager:DLogManager) {
			_name = name;
			_manager = manager;
		}
		
		public function toString():String {
			var out:String = "";
			for (var i:int = 0; i < _messages.length; i++) 
			{
				out += _messages[i].toString() + "\r\n";
			}
			return out;
		}
		
		public function get messages():Vector.<ConsoleMessage> {
			return _messages;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get prevMessage():ConsoleMessage {
			if (messages.length > 0)
				return messages[messages.length - 1];
			else
				return null;
		}
		
		public function destroy():void {
			if (_destroyed)
				return;
			_manager.removeLog(name);
			_manager = null;
			_destroyed = true;
		}
		
		public function get length():int {
			return messages.length;
		}
		
		public function clear():void {
			_messages = new Vector.<ConsoleMessage>();
			_dirty = true;
		}
		
		public function get dirty():Boolean {
			return _dirty;
		}
		
		public function get manager():DLogManager {
			return _manager;
		}
		
		public function addMessage(m:ConsoleMessage):void {
			_messages.push(m);
			_dirty = true;
		}
		
		public function setClean():void {
			_dirty = false;
		}
		
		public function setDirty():void {
			_dirty = true;
		}
	
	}

}
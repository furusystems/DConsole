package com.furusystems.dconsole2.core.utils {
	import com.furusystems.dconsole2.core.utils.LLNode;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	
	public final class ListIterator {
		private var _list:LLNode;
		public var currentNode:LLNode;
		private static const L:ILogger = Logging.getLogger(ListIterator);
		
		public function ListIterator(list:LLNode = null) {
			if (list == null)
				return;
			this.list = list;
		}
		
		public function next():* {
			if (currentNode == null)
				return null;
			currentNode = currentNode.next;
			if (currentNode == null)
				return null;
			return currentNode.data;
		}
		
		public function get data():* {
			if (currentNode == null)
				return null;
			return currentNode.data;
		}
		
		public function set list(list:LLNode):void {
			_list = list;
			currentNode = list.getHead();
		}
		
		public function remove():* {
			currentNode.remove();
		}
		
		public function get list():LLNode {
			return _list;
		}
	}
}
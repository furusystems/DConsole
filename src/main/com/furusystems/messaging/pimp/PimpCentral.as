package com.furusystems.messaging.pimp {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * Static or instanced Message central allowing app-wide Message broadcast as a complement to the event framework
	 * @author Andreas Rønning
	 */
	public final class PimpCentral {
		//{ statics
		private static const _recipientsTable:Dictionary = new Dictionary(true); //Table of vectors of recipients keyed by Message type
		private static const _callbacksTable:Dictionary = new Dictionary(true); //Table of vectors of callbacks keyed by Message type
		private static var _messageQueue:Vector.<MessageQueueItem> = new Vector.<MessageQueueItem>(); //Queue of Messages not yet sent (if delayed and delayed Message is enabled)
		private static const _updateSource:Shape = new Shape(); //Shape serving as source for frame update events (used with delay)
		private static var _delayEnabled:Boolean = false; //Local flag for delay functionality
		
		/**
		 * Dispatch a Message to all listeners for that specific Message object
		 * @param	n
		 * The Message to dispatch
		 * @param	origin
		 * (optional)
		 * The object that dispatched the Message
		 * @param	data
		 * (optional)
		 * Any payload to send along with the Message
		 * @param	delayMS
		 * (optional, dependent on delayEnabled) The number of milliseconds before the Message will be dispatched
		 */
		public static function send(m:Message, data:* = null, origin:Object = null, delayMS:Number = -1):void {
			var q:MessageQueueItem = new MessageQueueItem();
			q.message = m;
			q.origin = origin;
			q.delayMS = delayMS;
			q.data = data;
			if (delayMS <= 0 || !_delayEnabled) {
				processMessage(q);
				return;
			}
			q.delayMS += getTimer();
			_messageQueue.push(q);
		
		}
		
		/**
		 * Private handler for individual MessageQueueItems
		 * @param	queueItem
		 */
		private static function processMessage(queueItem:MessageQueueItem):void {
			var m:Message = queueItem.message;
			var o:Object = queueItem.origin;
			var d:Object = queueItem.data;
			var tempData:MessageData = new MessageData();
			tempData.message = m;
			tempData.source = queueItem.origin;
			tempData.data = queueItem.data;
			if (_recipientsTable[m] != null) {
				var table:Dictionary = _recipientsTable[m];
				for each (var listener:IMessageReceiver in table) {
					listener.onMessage(tempData);
				}
			}
			if (_callbacksTable[m] != null) {
				table = _callbacksTable[m];
				for each (var callback:Function in table) {
					switch (callback.length) {
						case 1:
							callback(tempData);
							break;
						case 0:
						default:
							callback();
					}
				}
			}
		}
		
		/**
		 * Private handler for frame events, handling delayed items
		 * @param	e
		 */
		private static function checkQueue(e:Event = null):void {
			if (_messageQueue.length == 0)
				return;
			var time:uint = getTimer();
			for (var i:int = _messageQueue.length; i--; ) {
				var n:MessageQueueItem = _messageQueue[i];
				if (n.delayMS <= time) {
					processMessage(n);
					_messageQueue.splice(i, 1); //TODO: may be linked list is better for this
				}
			}
		}
		
		/**
		 * Remove an IMessageReceiver from the receivers list for a specific Message
		 * @param	receiver
		 * The IMessageReceiver that shouldn't receive the Message anymore
		 * @param	Message
		 * The Message type the receiver shouldn't receive anymore
		 */
		public static function removeReceiver(receiver:IMessageReceiver, m:Message):void {
			if (_recipientsTable[m] == null)
				return;
			delete(_recipientsTable[m][receiver]);
		}
		
		/**
		 * Add an IMessageReceiver to the receivers list for a specific Message
		 * @param	receiver
		 * The IMessageReceiver that should receive the Message
		 * @param	Message
		 * The Message type the receiver should receive
		 * @parem ...rest
		 * More messages to receiver...
		 */
		public static function addReceiver(receiver:IMessageReceiver, m:Message, ... moreMessages:Array):void {
			appendReceiver(receiver, m);
			for each (m in moreMessages) {
				appendReceiver(receiver, m);
			}
		}
		
		private static function appendReceiver(receiver:IMessageReceiver, m:Message):void {
			var table:Dictionary;
			if (_recipientsTable[m] != null) {
				table = _recipientsTable[m];
			} else {
				table = _recipientsTable[m] = new Dictionary(true);
			}
			table[receiver] = receiver;
		}
		
		/**
		 * Adds a callback to be executed when a specific notofication is sent
		 * @param	Message
		 * The Message to respond to
		 * @param	callback
		 * The callback function, accepting either none or 1 argument ( an instance of MessageData)
		 * @param ...rest
		 * More messages to respond to with this callback...
		 */
		public static function addCallback(m:Message, callback:Function, ... moreMessages:Array):void {
			appendCallback(callback, m);
			for each (m in moreMessages) {
				appendCallback(callback, m);
			}
		}
		
		private static function appendCallback(callback:Function, m:Message):void {
			var table:Dictionary;
			if (_callbacksTable[m] != null) {
				table = _callbacksTable[m];
			} else {
				table = _callbacksTable[m] = new Dictionary(true);
			}
			table[callback] = callback;
		}
		
		/**
		 * Remove a callback from the execution list of a specific Message
		 * @param	callback
		 * The callback that should stop receiving the Message
		 * @param	m
		 * The Message that should stop triggering this callback
		 */
		public static function removeCallback(m:Message, callback:Function):void {
			if (_callbacksTable[m] == null)
				return;
			delete(_callbacksTable[m][callback]);
		}
		
		static public function get delayEnabled():Boolean {
			return _delayEnabled;
		}
		
		static public function set delayEnabled(value:Boolean):void {
			_delayEnabled = value;
			if (_delayEnabled) {
				_updateSource.addEventListener(Event.ENTER_FRAME, checkQueue);
			} else {
				_updateSource.removeEventListener(Event.ENTER_FRAME, checkQueue);
			}
		}
		//}
		
		//{ instance
		private const _recipientsTable:Dictionary = new Dictionary(true); //Table of vectors of recipients keyed by Message type
		private const _callbacksTable:Dictionary = new Dictionary(true); //Table of vectors of callbacks keyed by Message type
		private var _messageQueue:Vector.<MessageQueueItem> = new Vector.<MessageQueueItem>(); //Queue of Messages not yet sent (if delayed and delayed Message is enabled)
		private const _updateSource:Shape = new Shape(); //Shape serving as source for frame update events (used with delay)
		private var _delayEnabled:Boolean = false; //Local flag for delay functionality
		
		/**
		 * Dispatch a Message to all listeners for that specific Message object
		 * @param	n
		 * The Message to dispatch
		 * @param	origin
		 * (optional)
		 * The object that dispatched the Message
		 * @param	data
		 * (optional)
		 * Any payload to send along with the Message
		 * @param	delayMS
		 * (optional, dependent on delayEnabled) The number of milliseconds before the Message will be dispatched
		 */
		public function send(m:Message, data:* = null, origin:Object = null, delayMS:Number = -1):void {
			var q:MessageQueueItem = new MessageQueueItem();
			q.message = m;
			q.origin = origin;
			q.delayMS = delayMS;
			q.data = data;
			if (delayMS <= 0 || !_delayEnabled) {
				processMessage(q);
				return;
			}
			q.delayMS += getTimer();
			_messageQueue.push(q);
		
		}
		
		/**
		 * Private handler for individual MessageQueueItems
		 * @param	queueItem
		 */
		private function processMessage(queueItem:MessageQueueItem):void {
			var m:Message = queueItem.message;
			var o:Object = queueItem.origin;
			var d:Object = queueItem.data;
			var tempData:MessageData = new MessageData();
			tempData.message = m;
			tempData.source = queueItem.origin;
			tempData.data = queueItem.data;
			if (_recipientsTable[m] != null) {
				var table:Dictionary = _recipientsTable[m];
				for each (var listener:IMessageReceiver in table) {
					listener.onMessage(tempData);
				}
			}
			if (_callbacksTable[m] != null) {
				table = _callbacksTable[m];
				for each (var callback:Function in table) {
					switch (callback.length) {
						case 1:
							callback(tempData);
							break;
						case 0:
						default:
							callback();
					}
				}
			}
		}
		
		/**
		 * Private handler for frame events, handling delayed items
		 * @param	e
		 */
		private function checkQueue(e:Event = null):void {
			if (_messageQueue.length == 0)
				return;
			var time:uint = getTimer();
			for (var i:int = _messageQueue.length; i--; ) {
				var n:MessageQueueItem = _messageQueue[i];
				if (n.delayMS <= time) {
					processMessage(n);
					_messageQueue.splice(i, 1); //TODO: may be linked list is better for this
				}
			}
		}
		
		/**
		 * Remove an IMessageReceiver from the receivers list for a specific Message
		 * @param	receiver
		 * The IMessageReceiver that shouldn't receive the Message anymore
		 * @param	Message
		 * The Message type the receiver shouldn't receive anymore
		 */
		public function removeReceiver(receiver:IMessageReceiver, m:Message):void {
			if (_recipientsTable[m] == null)
				return;
			delete(_recipientsTable[m][receiver]);
		}
		
		/**
		 * Add an IMessageReceiver to the receivers list for a specific Message
		 * @param	receiver
		 * The IMessageReceiver that should receive the Message
		 * @param	Message
		 * The Message type the receiver should receive
		 * @parem ...rest
		 * More messages to receiver...
		 */
		public function addReceiver(receiver:IMessageReceiver, m:Message, ... moreMessages:Array):void {
			appendReceiver(receiver, m);
			for each (m in moreMessages) {
				appendReceiver(receiver, m);
			}
		}
		
		private function appendReceiver(receiver:IMessageReceiver, m:Message):void {
			var table:Dictionary;
			if (_recipientsTable[m] != null) {
				table = _recipientsTable[m];
			} else {
				table = _recipientsTable[m] = new Dictionary(true);
			}
			table[receiver] = receiver;
		}
		
		/**
		 * Adds a callback to be executed when a specific notofication is sent
		 * @param	Message
		 * The Message to respond to
		 * @param	callback
		 * The callback function, accepting either none or 1 argument ( an instance of MessageData)
		 * @param ...rest
		 * More messages to respond to with this callback...
		 */
		public function addCallback(m:Message, callback:Function, ... moreMessages:Array):void {
			appendCallback(callback, m);
			for each (m in moreMessages) {
				appendCallback(callback, m);
			}
		}
		
		private function appendCallback(callback:Function, m:Message):void {
			var table:Dictionary;
			if (_callbacksTable[m] != null) {
				table = _callbacksTable[m];
			} else {
				table = _callbacksTable[m] = new Dictionary(true);
			}
			table[callback] = callback;
		}
		
		/**
		 * Remove a callback from the execution list of a specific Message
		 * @param	callback
		 * The callback that should stop receiving the Message
		 * @param	m
		 * The Message that should stop triggering this callback
		 */
		public function removeCallback(m:Message, callback:Function):void {
			if (_callbacksTable[m] == null)
				return;
			delete(_callbacksTable[m][callback]);
		}
		
		public function get delayEnabled():Boolean {
			return _delayEnabled;
		}
		
		public function set delayEnabled(value:Boolean):void {
			_delayEnabled = value;
			if (_delayEnabled) {
				_updateSource.addEventListener(Event.ENTER_FRAME, checkQueue);
			} else {
				_updateSource.removeEventListener(Event.ENTER_FRAME, checkQueue);
			}
		}
	
		//}
	}
}
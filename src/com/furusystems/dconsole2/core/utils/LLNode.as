package com.furusystems.dconsole2.core.utils 
{
	import com.furusystems.dconsole2.core.interfaces.IDisposable;
	/**
	 * Generic doubly linked list node. Can serve as head, tail or whatever
	 * @author Andreas Ronning
	 */
	public final class LLNode implements IDisposable
	{
		public var data:* = null;
		public var next:LLNode = null;
		public var prev:LLNode = null;
		/**
		 * Create a new node with data
		 * @param	data
		 */
		public function LLNode(data:*) 
		{
			this.data = data;
		}
		/**
		 * Adds a node to the back of this node 
		 * If THIS node has no data, this node is populated instead
		 * @param	data The data to append
		 * @return The newly created node
		 */
		public function append(data:*):LLNode {
			if (this.data == null) {
				this.data = data;
				return this;
			}
			var node:LLNode = new LLNode(data);
			node.prev = this;
			if (hasNext) {
				next.prev = node;
				node.next = next;
			}
			next = node;
			return node;
		}
		/**
		 * Adds a node to the front of this node. 
		 * If THIS node has no data, this node is populated instead
		 * @param	data The data to prepend
		 * @return The newly created node
		 */
		public function prepend(data:*):LLNode {
			if (this.data == null) {
				this.data = data;
				return this;
			}
			var node:LLNode = new LLNode(data);
			node.next = this;
			if (hasPrev) {
				prev.next = node;
				node.prev = prev;
			}
			prev = node;
			return node;
		}
		/**
		 * Does this node have a trailing node?
		 */
		public function get hasNext():Boolean {
			return next != null;
		}
		/**
		 * Does this node have a preceding node?
		 */
		public function get hasPrev():Boolean {
			return prev != null;
		}
		
		/**
		 * Get the last node in this list
		 * @return
		 */
		public function getTail():LLNode {
			if (hasNext) {
				return next.getTail();
			}
			return this;
		}
		/**
		 * Get the first node in this list
		 * @return
		 */
		public function getHead():LLNode {
			if (hasPrev) {
				return prev.getHead();
			}
			return this;
		}
		
		/**
		 * Removes this node from the list. 
		 * If it is the head, it merges with the next node in the list, taking on its data
		 * If it is the tail, it removes the reference to itself and disposes
		 * If it's the last item in the list, it disposes
		 */
		public function remove():* 
		{
			var d:*;
			if (!hasNext && !hasPrev) {
				d = data;
				dispose();
				return d;
			}
			
			if (hasNext) {
				next.prev = prev;
			}else {
				prev.next = null;
				d = data;
				dispose();
				return d;
			}
			
			if (hasPrev) {
				prev.next = next;
			}else {
				d = data;
				merge(next);
				//prev = null;
				return d;
			}
			return data;
		}
		/**
		 * Absorbs attributes of a given node, and then disposes the target node
		 * @param	node
		 */
		private function merge(node:LLNode):void {
			data = node.data;
			next = node.next;
			prev = node.prev;
			if (hasNext) {
				next.prev = this;
			}
			if (hasPrev) {
				prev.next = this;
			}
			node.dispose();
		}
		
		/**
		 * Clear this node's data and linked list position
		 * You should use remove() instead to maintain list contiguity
		 */
		public function dispose():void 
		{
			data = null;
			next = prev = null;
		}
		
		/**
		 * Gets the head of the list, and removes every node from the tail back
		 * @param disposeDisposables If any node data is found that implements IDisposable, dispose it
		 * @return The number of removed nodes
		 */
		public function clearList(disposeDisposables:Boolean = false):int {
			var head:LLNode = getHead();
			if (head == this) {
				var count:int = 0;
				while (size > 0) {
					count++;
					var ob:* = getTail().remove();
					if(disposeDisposables){
						if (ob is IDisposable) {
							IDisposable(ob).dispose();
						}
					}
				}
				return count;
			}else{
				return head.clearList();
			}
		}
		
		/**
		 * Executes a callback on the data of every node following this node
		 * @param	func 
		 */
		public function forEach(func:Function):void {
			if (func.length != 1) {
				throw new ArgumentError("Function must have exactly one argument");
			}
			var n:LLNode = this;
			func(n.data);
			while (n.hasNext) {
				n = n.next;
				func(n.data);
			}
		}
		public function toString():String 
		{
			return "[LLNode data=" + data + " hasNext=" + hasNext + " hasPrev=" + hasPrev + "]";
		}
		/**
		 * Retrieve a node by its list index
		 * @param	idx
		 * @return
		 */
		public function getByIndex(idx:int):LLNode {
			var out:LLNode = getHead();
			var count:int = 0;
			while (out.hasNext) {
				if (count == idx) return out;
				count++;
				out = out.next;
			}
			return null;
		}
		/**
		 * Retrieve a node by its data
		 * @param	data
		 * @return
		 */
		public function getByData(data:*):LLNode {
			var out:LLNode = getHead();
			while (out.hasNext) {
				if (out.data == data) return out;
				out = out.next;
			}
			return null;
		}
		
		/**
		 * Execute a function for every node's data, and if it returns true, add that data to a new list
		 * @param	func A filtering function taking at least one argument
		 * @param rest Any arguments to append to the filtering function
		 * @return
		 */
		public function filter(func:Function, ...args:Array):LLNode {
			var out:LLNode = new LLNode(null);
			var n:LLNode = getHead();
			while (n.hasNext) {
				if (func(n.data)) {
					out.append(n.data);
				}
				n = n.next;
			}
			return out;
		}
		/**
		 * Execute a function for every node's data, and if it returns true, add it to a list.
		 * @param	func A filtering function taking at least one argument
		 * @param rest Any arguments to append to the filtering function
		 * @return An untyped vector
		 */
		public function filterToArray(func:Function, ...args:Array):Array{
			var out:Array = [];
			var n:LLNode = getHead();
			while (n.hasNext) {
				if (func(n.data)) {
					out.push(n.data);
				}
				n = n.next;
			}
			return out;
		}
		public function contains(data:*):Boolean {
			return getByData(data)!=null;
		}
		/**
		 * Steps through the list and removes any nodes with null data
		 * @return The number of items that were removed
		 */
		public function consolidate():int {
			var head:LLNode = getHead();
			if (head == this) {
				var nodesToRemove:Vector.<LLNode> = new Vector.<LLNode>();
				var n:LLNode = head;
				while (n.hasNext) {
					n = n.next;
					if (n.data == null) nodesToRemove.push(n);
				}
				for each(n in nodesToRemove) {
					n.remove();
				}
				return nodesToRemove.length;
			}else{
				return head.consolidate();
			}
		}
		
		/**
		 * Count nodes and get a list size
		 */
		public function get size():int {
			var out:LLNode = getHead();
			var size:int = out.data == null?0:1;
			while (out.hasNext) {
				out = out.next;
				size ++;
			}
			return size;
		}
		public function getIterator():ListIterator {
			return new ListIterator(this);
		}
		
	}
}
package com.furusystems.dconsole2.plugins.inspectorviews.treeview 
{
	import flash.display.Sprite;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.noderenderers.ListNode;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ListSection extends Sprite implements IRenderable
	{
		private var items:Vector.<ListNode> = new Vector.<ListNode>();
		private var _level:int;
		private var _parent:ListNode;
		public var expanded:Boolean = false;
		public function ListSection(parent:ListNode,level:int = 0) 
		{
			this._parent = parent;
			_level = level;
			
		}
		public function render():void {
			
		}
		//public function clear():void;
		
		public function get level():int { return _level; }
		
		public function set level(value:int):void 
		{
			_level = value;
		}
		
	}

}
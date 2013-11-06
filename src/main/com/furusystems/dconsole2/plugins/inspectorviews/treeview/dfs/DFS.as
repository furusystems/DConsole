package com.furusystems.dconsole2.plugins.inspectorviews.treeview.dfs
{
	import flash.display.DisplayObject;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.noderenderers.ListNode;
	public class DFS
	{
		public static function search(destination:DisplayObject, origin:ListNode):ListNode {
			if (destination == origin.displayObject) return origin;
			var closedList:Vector.<ListNode> = new Vector.<ListNode>();
			var openList:Vector.<ListNode> = new Vector.<ListNode>();
			openList.push(origin);
			while (openList.length != 0) {
				var n:ListNode = openList.shift();
				if (n.displayObject == destination) {
					return n;
				}
				if (!n.childNodes) n.buildChildren();
				n.expanded = false;
				var neighbors:Vector.<ListNode> = n.childNodes;
				var nLength:Number = neighbors.length;
				
				for (var i:int =0; i< nLength; i++) {
					openList.unshift(neighbors[nLength - i - 1]);
				}
				
				closedList.push(n);
			}
			return null;
		}
	}

}
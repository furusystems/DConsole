package com.furusystems.dconsole2.core.introspection 
{
	import com.furusystems.dconsole2.core.introspection.descriptions.ChildScopeDesc;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class TreeUtils
	{
		
		public function TreeUtils() 
		{
			
		}
		public static function getChildren(o:*):Vector.<ChildScopeDesc> {
			var out:Vector.<ChildScopeDesc> = new Vector.<ChildScopeDesc>();
			//if we're in a DisplayObjectContainer, add first level children
			var c:ChildScopeDesc;
			if (o is DisplayObjectContainer) {
				var d:DisplayObjectContainer = o as DisplayObjectContainer;
				var cd:DisplayObject;
				var n:int = d.numChildren;
				for (n > 0; n--; ) {
					cd = d.getChildAt(n);
					c = new ChildScopeDesc();
					c.object = cd;
					c.name = cd.name;
					c.type = cd.toString();
					out.push(c);
				}
			}
			return out;
		}
		
	}

}
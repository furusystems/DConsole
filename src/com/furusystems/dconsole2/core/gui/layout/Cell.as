package com.furusystems.dconsole2.core.gui.layout {
	import com.furusystems.dconsole2.core.DSprite;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * Layout cell, describing a rectangle that may contain cells of its own
	 * @author Andreas Roenning
	 */
	public class Cell extends DSprite implements ILayoutContainer {
		protected var _rect:Rectangle;
		protected var _children:Array = [];
		public static const ROUND_VALUES:Boolean = false;
		
		public function Cell() {
			_rect = new Rectangle();
		}
		
		/* INTERFACE layout.ILayoutContainer */
		
		public function set rect(r:Rectangle):void {
			if (ROUND_VALUES) {
				r.x = int(r.x);
				r.y = int(r.y);
				r.width = int(r.width);
				r.height = int(r.height);
			}
			//x = r.x;
			y = r.y;
			_rect = r;
			onRectangleChanged();
		}
		
		public function get rect():Rectangle {
			return _rect;
		}
		
		protected function onRectangleChanged():void {
		
		}
		
		/* INTERFACE layout.ILayoutContainer */
		
		public function get children():Array {
			return _children;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			_children.push(child);
			return super.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			var idx:int = _children.indexOf(child);
			if (idx > -1) {
				_children.splice(idx, 1);
			}
			return super.removeChild(child);
		}
		
		public function onParentUpdate(allotedRect:Rectangle):void {
			rect = allotedRect;
			for each (var i:IContainable in children) {
				i.onParentUpdate(rect);
			}
		}
		
		public function get minHeight():Number {
			return 0;
		}
		
		public function get minWidth():Number {
			return 0;
		}
	
	}

}
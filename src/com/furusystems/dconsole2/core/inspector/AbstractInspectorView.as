package com.furusystems.dconsole2.core.inspector {
	import com.furusystems.dconsole2.core.errors.NotImplementedError;
	import com.furusystems.dconsole2.core.inspector.IInspectorView;
	import com.furusystems.dconsole2.core.plugins.IDConsoleInspectorPlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class AbstractInspectorView extends Sprite implements IInspectorView, IDConsoleInspectorPlugin {
		private var _scrollXEnabled:Boolean = true;
		private var _scrollYEnabled:Boolean = true;
		public var inspector:Inspector;
		protected var _scrollMargin:Number;
		protected var _bounds:Rectangle;
		private var _scrollableContent:Sprite = new Sprite();
		private var _title:String;
		
		public function AbstractInspectorView(title:String) {
			_title = title;
			addChild(_scrollableContent);
			_scrollableContent.scrollRect = new Rectangle();
			_scrollMargin = 0;
			addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
		}
		
		private function onAddedtoStage(e:Event):void {
			onShow();
		}
		
		protected function onShow():void {
			
		}
		
		public function associateWithInspector(inspector:Inspector):void {
			this.inspector = inspector;
		}
		
		public function scrollByDelta(x:Number, y:Number):void {
			scrollX -= x;
			scrollY -= y;
		}
		
		public function get scrollX():Number {
			return scrollRect.x;
		}
		
		public function get scrollY():Number {
			return scrollRect.y;
		}
		
		public function onFrameUpdate(e:Event = null):void {
		
		}
		
		public function setWidthHeight(w:Number, h:Number):void {
			var s:Rectangle = scrollRect;
			s.width = w;
			s.height = h;
			scrollRect = s;
			scrollByDelta(0, 0);
		}
		
		override public function get scrollRect():Rectangle {
			return _scrollableContent.scrollRect;
		}
		
		override public function set scrollRect(value:Rectangle):void {
			_scrollableContent.scrollRect = value;
		}
		
		public function populate(object:Object):void {
		}
		
		public function set scrollX(n:Number):void {
			var s:Rectangle = scrollRect;
			calcBounds();
			if (scrollXEnabled) {
				s.x = n;
				var diffX:Number = (_bounds.width - scrollRect.width);
				s.x = Math.max(-_scrollMargin, Math.min(s.x, diffX + _scrollMargin));
			} else {
				s.x = -_scrollMargin;
			}
			scrollRect = s;
		}
		
		protected function calcBounds():Rectangle {
			return _bounds = _scrollableContent.transform.pixelBounds;
		}
		
		public function get scrollXEnabled():Boolean {
			if (_scrollXEnabled)
				return _bounds.width > scrollRect.width;
			return false;
		}
		
		public function get scrollYEnabled():Boolean {
			if (_scrollYEnabled)
				return _bounds.height > scrollRect.height;
			return false;
		}
		
		public function get availableWidth():Number {
			return scrollRect.width;
		}
		
		public function get availableHeight():Number {
			return scrollRect.height;
		}
		
		public function set scrollXEnabled(b:Boolean):void {
			_scrollXEnabled = b;
		}
		
		public function set scrollYEnabled(b:Boolean):void {
			_scrollYEnabled = b;
		}
		
		public function set scrollY(n:Number):void {
			calcBounds();
			var s:Rectangle = scrollRect;
			if (scrollYEnabled) {
				s.y = n;
				var diffY:Number = (_bounds.height - scrollRect.height);
				s.y = Math.max(-_scrollMargin, Math.min(s.y, diffY + _scrollMargin));
			} else {
				s.y = -_scrollMargin;
			}
			scrollRect = s;
		}
		
		public function get maxScrollY():Number {
			return _scrollableContent.transform.pixelBounds.height - scrollRect.height;
		}
		
		public function get maxScrollX():Number {
			return _scrollableContent.transform.pixelBounds.width - scrollRect.width;
		}
		
		public function beginDragging():void {
			Mouse.cursor = MouseCursor.HAND;
			mouseChildren = false;
		}
		
		public function stopDragging():void {
			Mouse.cursor = MouseCursor.AUTO;
			mouseChildren = true;
		}
		
		public function resize():void {
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsoleInspectorPlugin */
		
		public function get view():AbstractInspectorView {
			return this;
		}
		
		public function get title():String {
			return _title;
		}
		
		public function update(pm:PluginManager):void {
		
		}
		
		public function get descriptionText():String {
			return "";
		}
		
		public function initialize(pm:PluginManager):void {
		}
		
		public function shutdown(pm:PluginManager):void {
		}
		
		public function get dependencies():Vector.<Class> {
			return null;
		}
		
		public function get content():Sprite 
		{
			return _scrollableContent;
		}
	
	}

}
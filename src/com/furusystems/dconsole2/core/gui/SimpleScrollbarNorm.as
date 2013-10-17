package com.furusystems.dconsole2.core.gui 
{
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.StyleManager;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class SimpleScrollbarNorm extends Sprite implements IThemeable
	{
		public static const VERTICAL:int = 0;
		public static const HORIZONTAL:int = 1;
		private var orientation:int;
		public var trackWidth:Number = 4;
		public var thumbWidth:Number = 4;
		public var minThumbWidth:Number = thumbWidth;
		private var length:Number = 0;
		public var outValue:Number = 0;
		private var clickOffset:Number = 0;
		private var thumbPos:Number;
		private var _thumbColor:uint = Colors.SCROLLBAR_FG;
		public var jumpToClick:Boolean = true;
		private var _bgColor:uint = 0;
		public function SimpleScrollbarNorm(orientation:int) 
		{
			this.orientation = orientation;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			//messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
		}
		
		private function startDragging(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, doScroll);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			if (jumpToClick) {
				thumbPos = mouseY;
			}
			switch(orientation) {
				case VERTICAL:
					clickOffset = mouseY-thumbPos;
				break;
				case HORIZONTAL:
					clickOffset = mouseX-thumbPos;
				break;
			}
			doScroll();
		}
		
		private function stopDragging(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, doScroll);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}
		
		private function doScroll(e:MouseEvent = null):void 
		{
			switch(orientation) {
				case VERTICAL:
				outValue = Math.max(0, Math.min(1, (mouseY - clickOffset) / (length - thumbWidth)));
				break;
				case HORIZONTAL:
				outValue = Math.max(0, Math.min(1, (mouseX - clickOffset) / (length - thumbWidth)));
				break;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function draw(length:Number, currentScroll:Number, maxScroll:Number):void { 
			this.length = length;
			graphics.clear();
			graphics.beginFill(Colors.SCROLLBAR_BG);
			currentScroll = Math.min(maxScroll, currentScroll);
					
			//TODO: Dynamic thumb height
			switch(orientation) {
				case VERTICAL:
				//thumbWidth = Math.max(minThumbWidth, currentScroll / maxScroll * length);
				thumbWidth = minThumbWidth;
				thumbPos = (currentScroll / maxScroll) * (length-thumbWidth);
				graphics.drawRect(0, 0, trackWidth, length);
				graphics.beginFill(Colors.SCROLLBAR_FG);
				graphics.drawRect(0, thumbPos, trackWidth, thumbWidth);
				
				break;
				case HORIZONTAL:
				//thumbWidth = Math.max(minThumbWidth, currentScroll / maxScroll * length);
				thumbWidth = minThumbWidth;
				thumbPos = (currentScroll / maxScroll) * length;
				graphics.drawRect(0, 0, length, trackWidth);
				graphics.beginFill(Colors.SCROLLBAR_FG);
				graphics.drawRect(thumbPos,0 , thumbWidth, trackWidth);
				break;
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData):void
		{
			var sm:StyleManager = StyleManager(md.source);
		}
		
	}

}
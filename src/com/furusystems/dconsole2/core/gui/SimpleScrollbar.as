package com.furusystems.dconsole2.core.gui 
{
	import com.furusystems.dconsole2.core.style.Colors;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class SimpleScrollbar extends Sprite
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
		public function SimpleScrollbar(orientation:int) 
		{
			this.orientation = orientation;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
		}
		
		private function startDragging(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, doScroll);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
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
		public function draw(length:Number, viewRect:Rectangle, currentScroll:Number, maxScroll:Number):void { 
			this.length = length;
			graphics.clear();
			graphics.beginFill(Colors.SCROLLBAR_BG);
			currentScroll = Math.min(maxScroll, currentScroll);
					
			switch(orientation) {
				case VERTICAL:
				thumbWidth = Math.max(minThumbWidth, (viewRect.height / maxScroll) * length);
				thumbPos = (currentScroll / maxScroll) * length;
				graphics.drawRect(0, 0, trackWidth, length);
				graphics.beginFill(Colors.SCROLLBAR_FG);
				graphics.drawRect(0, thumbPos, trackWidth, thumbWidth);
				
				break;
				case HORIZONTAL:
				thumbWidth = Math.max(minThumbWidth, (viewRect.width / maxScroll) * length);
				thumbPos = (currentScroll / maxScroll) * length;
				graphics.drawRect(0, 0, length, trackWidth);
				graphics.beginFill(Colors.SCROLLBAR_FG);
				graphics.drawRect(thumbPos,0 , thumbWidth, trackWidth);
				break;
			}
		}
		
	}

}
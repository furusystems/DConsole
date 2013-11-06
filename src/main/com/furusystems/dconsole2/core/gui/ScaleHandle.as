package com.furusystems.dconsole2.core.gui {
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.strings.Strings;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ScaleHandle extends Sprite implements IContainable, IThemeable {
		
		private var _dragging:Boolean = false;
		private var allotedRect:Rectangle;
		private var console:DConsole;
		
		public function ScaleHandle(console:DConsole) {
			this.console = console;
			//buttonMode = true;
			doubleClickEnabled = true;
			tabEnabled = false;
			//var dsf:DropShadowFilter = new DropShadowFilter(0, 90, 0, 1, 4, 4, 1, 1, true);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			alpha = 0;
			console.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
		}
		
		private function onMouseOut(e:MouseEvent):void {
			console.messaging.send(Notifications.ASSISTANT_CLEAR_REQUEST);
		}
		
		private function onMouseOver(e:MouseEvent):void {
			console.messaging.send(Notifications.ASSISTANT_MESSAGE_REQUEST, Strings.ASSISTANT_STRINGS.get(Strings.ASSISTANT_STRINGS.SCALE_HANDLE_ID), this);
		}
		
		private function onRollOut(e:MouseEvent):void {
			if (dragging)
				return;
			alpha = 0;
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function onRollOver(e:MouseEvent):void {
			alpha = 1;
			Mouse.cursor = MouseCursor.HAND;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle):void {
			this.allotedRect = allotedRect;
			graphics.clear();
			x = allotedRect.x;
			y = allotedRect.y;
			graphics.beginFill(Colors.SCALEHANDLE_BG, 1);
			var h:Number = GUIUnits.SQUARE_UNIT / 2;
			graphics.drawRect(0, 0, allotedRect.width, h);
			graphics.endFill();
			graphics.lineStyle(0, Colors.SCALEHANDLE_FG);
			graphics.moveTo(3, h / 2);
			graphics.lineTo(allotedRect.width - 3, h / 2);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData):void {
			graphics.clear();
			x = allotedRect.x;
			y = allotedRect.y;
			graphics.beginFill(Colors.SCALEHANDLE_BG, 1);
			var h:Number = GUIUnits.SQUARE_UNIT / 2;
			graphics.drawRect(0, 0, allotedRect.width, h);
			graphics.endFill();
			graphics.lineStyle(0, Colors.SCALEHANDLE_FG);
			graphics.moveTo(3, h / 2);
			graphics.lineTo(allotedRect.width - 3, h / 2);
		}
		
		public function get rect():Rectangle {
			return getRect(parent);
		}
		
		public function get minHeight():Number {
			return 0;
		}
		
		public function get minWidth():Number {
			return 0;
		}
		
		public function get dragging():Boolean {
			return _dragging;
		}
		
		public function set dragging(value:Boolean):void {
			_dragging = value;
			if (value)
				alpha = 1;
			else
				alpha = 0;
		}
	
	}

}
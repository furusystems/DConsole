package com.furusystems.dconsole2.core.gui.maindisplay.sections 
{
	import com.furusystems.dconsole2.core.gui.maindisplay.toolbar.ConsoleToolbar;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.strings.Strings;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class HeaderSection extends ConsoleViewSection
	{
		
		public var toolBar:ConsoleToolbar;
		private var _delta:Point = new Point();
		private var _prevDragPos:Point = new Point();
		private var _console:IConsole;
		public function HeaderSection(console:IConsole) 
		{
			_console = console;
			toolBar = new ConsoleToolbar(console);
			addChild(toolBar);
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			_console.messaging.send(Notifications.ASSISTANT_CLEAR_REQUEST);
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			_console.messaging.send(Notifications.ASSISTANT_MESSAGE_REQUEST, Strings.ASSISTANT_STRINGS.get(Strings.ASSISTANT_STRINGS.HEADER_BAR_ID), this);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_prevDragPos.x = stage.mouseX;
			_prevDragPos.y = stage.mouseY;
			_console.messaging.send(Notifications.TOOLBAR_DRAG_START, _prevDragPos, this);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			_delta.x = stage.mouseX - _prevDragPos.x;
			_delta.y = stage.mouseY - _prevDragPos.y;
			_prevDragPos.x = stage.mouseX;
			_prevDragPos.y = stage.mouseY;
			_console.messaging.send(Notifications.TOOLBAR_DRAG_UPDATE, _delta, this);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			_delta.x = stage.mouseX - _prevDragPos.x;
			_delta.y = stage.mouseY - _prevDragPos.y;
			_prevDragPos.x = stage.mouseX;
			_prevDragPos.y = stage.mouseY;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_console.messaging.send(Notifications.TOOLBAR_DRAG_STOP, _delta, this);
		}
		override public function onParentUpdate(allotedRect:Rectangle):void 
		{
			visible = allotedRect.height >= 80;
			toolBar.onParentUpdate(allotedRect);
		}
		
	}

}
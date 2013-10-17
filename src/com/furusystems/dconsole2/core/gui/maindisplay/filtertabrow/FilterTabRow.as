package com.furusystems.dconsole2.core.gui.maindisplay.filtertabrow 
{
	import com.furusystems.dconsole2.core.DSprite;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.logmanager.DLogManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * A row of buttons letting you select the currently focused tag
	 * @author Andreas Roenning
	 */
	public class FilterTabRow extends Sprite implements IContainable,IThemeable
	{
		private var _rect:Rectangle = new Rectangle();
		
		private var _filters:Vector.<String> = new Vector.<String>();
		private var _logManager:DLogManager;
		private var _buttonContainer:DSprite = new DSprite();
		private var _scrollPos:Number = 0;
		private var _clickOffsetX:Number = 0;
		private var _scrolling:Boolean = false;
		private var _buttons:Array;
		private var _console:IConsole;
		public function FilterTabRow(console:IConsole) 
		{
			_console = console;
			_console.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			_console.messaging.addCallback(Notifications.NEW_LOG_CREATED, onLogCreated);
			_console.messaging.addCallback(Notifications.LOG_DESTROYED, onLogDestroyed);
			_console.messaging.addCallback(Notifications.CURRENT_LOG_CHANGED, onCurrentLogChange);
			addChild(_buttonContainer);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (!scrollEnabled) return;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_clickOffsetX = mouseX;
		}
		private function onMouseMove(e:MouseEvent):void 
		{
			var dx:Number = mouseX - _clickOffsetX;
			if (Math.sqrt(dx * dx) > 5) {
				_scrolling = true;
				_buttonContainer.mouseEnabled = _buttonContainer.mouseChildren = false;
			}
			if(_scrolling) updateScroll();
		}
		
		private function updateScroll():void
		{
			var deltaX:Number = mouseX - _clickOffsetX;
			_clickOffsetX = mouseX;
			_buttonContainer.x += deltaX;
			consolidateScrollPos();
		}
		private function get scrollEnabled():Boolean {
			var rect:Rectangle = _buttonContainer.transform.pixelBounds;
			var diffX:Number = (rect.width - scrollRect.width);
			return diffX > 0;
		}
		private function consolidateScrollPos():void
		{
			var rect:Rectangle = _buttonContainer.transform.pixelBounds;
			var diffX:Number = (rect.width - scrollRect.width);
			_buttonContainer.x = Math.max(-diffX, Math.min(_buttonContainer.x, 0));
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_buttonContainer.mouseEnabled = _buttonContainer.mouseChildren = true;
		}
		
		private function onCurrentLogChange(md:MessageData):void
		{
			_logManager = md.source as DLogManager;
			var a:Array = _buttonContainer.getChildren();
			for each(var btn:FilterTabButton in a) {
				btn.active = btn.logName.toLowerCase() == _logManager.currentLog.name.toLowerCase();
			}
		}
		
		private function onLogDestroyed(md:MessageData):void
		{
			_logManager = md.source as DLogManager;
			updateButtons();
		}
		
		private function updateButtons():void
		{
			_buttonContainer.removeAllChildren();
			var btnNames:Vector.<String> = _logManager.getLogNames();
			_buttons = [];
			for (var i:int = 0; i < btnNames.length; i++) 
			{
				var btn:FilterTabButton = new FilterTabButton(_console, btnNames[i]);
				if (btn.logName.toLowerCase() == _logManager.currentLog.name.toLowerCase()) {
					btn.active = true;
				}
				_buttons.push(btn);
			}
			_buttonContainer.addChildren(_buttons, 0);
		}
		
		private function onLogCreated(md:MessageData):void
		{
			_logManager = md.source as DLogManager;
			updateButtons();
		}
		public function redraw(width:Number):void {
			graphics.clear();
			graphics.beginFill(Colors.FILTER_BG);
			graphics.drawRect(0, 0, width, GUIUnits.SQUARE_UNIT);
			scrollRect = new Rectangle(0, 0, width, GUIUnits.SQUARE_UNIT);
			for each(var b:FilterTabButton in _buttons) {
				b.redraw();
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle):void
		{
			_rect = allotedRect;
			y = _rect.y;
			x = _rect.x;
			redraw(_rect.width);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData):void
		{
			redraw(_rect.width);
		}
		
		public function get rect():Rectangle
		{
			return getRect(parent);
		}
		
		public function get minHeight():Number
		{
			return 0;
		}
		
		public function get minWidth():Number
		{
			return 0;
		}
		
	}

}
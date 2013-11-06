package com.furusystems.dconsole2.plugins.measurebracket 
{
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.Message;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.style.BaseColors;
	import com.furusystems.dconsole2.DConsole;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class MeasurementBracketUtil extends Sprite implements IDConsolePlugin
	{
		private var _rect:Rectangle = new Rectangle();
		private var _rectSprite:Sprite;
		private var _initialized:Boolean = false;
		private var _topLeftCornerHandle:Sprite;
		private var _bottomRightCornerHandle:Sprite;
		private var _widthField:TextField;
		private var _heightField:TextField;
		private var _xyField:TextField;
		private var _fmt:TextFormat;
		private var _currentlyChecking:Sprite;
		private var _increment:Number = -1;
		private var _console:IConsole;
		private var _previousObj:Object;
		private var _scopeManager:ScopeManager;
		private var _selectMode:Boolean = false;
		private var _currentSpace:DisplayObject;
		public var clickOffset:Point;
		public function MeasurementBracketUtil() 
		{
			visible = false;
		}
		public function invoke(doSelect:Boolean = false, space:DisplayObject = null):void {
			if (space) {
				_currentSpace = space;
			}
			if (doSelect) {
				_selectMode = doSelect;
				visible = true;
				_console.print("	Snap-selection active. Ctrl-drag to bracket AND select underlying objects.", ConsoleMessageTypes.SYSTEM);
			}else {
				toggle();
			}
		}
		private function roundTo(num:Number, target:Number):Number {
			return Math.round(num / target) * target;
		}
		private function onVisible():void 
		{
			if (!_initialized) {
				_fmt = new TextFormat("_sans", 10, 0);
				_widthField = new TextField();
				_heightField = new TextField();
				_xyField = new TextField();
				_widthField.defaultTextFormat = _heightField.defaultTextFormat = _xyField.defaultTextFormat = _fmt;
				var center:Point = new Point(_console.view.stage.stageWidth / 2, _console.view.stage.stageHeight / 2);
				_rect = new Rectangle(center.x - 20, center.y - 20, 40, 40);
				
				_rectSprite = new Sprite();
				_topLeftCornerHandle = new Sprite();
				_bottomRightCornerHandle = new Sprite();
				
				_topLeftCornerHandle.graphics.beginFill(BaseColors.BLACK);
				_topLeftCornerHandle.graphics.lineStyle(0, 0xFF0000);
				_bottomRightCornerHandle.graphics.beginFill(BaseColors.BLACK);
				_bottomRightCornerHandle.graphics.lineStyle(0, 0xFF0000);
				_topLeftCornerHandle.graphics.drawCircle(0, 0, 4);
				_bottomRightCornerHandle.graphics.drawCircle(0, 0, 4);
				
				_topLeftCornerHandle.addEventListener(MouseEvent.MOUSE_DOWN, startGettingValues, false, 0, true);
				_bottomRightCornerHandle.addEventListener(MouseEvent.MOUSE_DOWN, startGettingValues, false, 0, true);
				_rectSprite.addEventListener(MouseEvent.MOUSE_DOWN, startGettingValues, false, 0, true);
				
				_rectSprite.buttonMode = _topLeftCornerHandle.buttonMode = _bottomRightCornerHandle.buttonMode = true;
				
				addChild(_rectSprite);
				addChild(_topLeftCornerHandle);
				addChild(_bottomRightCornerHandle);
				
				_xyField.mouseEnabled = _widthField.mouseEnabled = _heightField.mouseEnabled = false;
				
				_xyField.autoSize = _widthField.autoSize = _heightField.autoSize = TextFieldAutoSize.LEFT;
				
				addChild(_xyField);
				addChild(_widthField);
				addChild(_heightField);
				
				_initialized = true;
				tabEnabled = tabChildren = false;
			}
			
			blendMode = BlendMode.INVERT;
			render();
		}
		
		private function startGettingValues(e:MouseEvent):void 
		{
			_currentlyChecking = e.target as Sprite;
			if (_currentlyChecking == _rectSprite) clickOffset = new Point(mouseX - _rect.x, mouseY - _rect.y);
			_console.view.stage.addEventListener(MouseEvent.MOUSE_MOVE, getValues, false, 0, true);
			_console.view.stage.addEventListener(MouseEvent.MOUSE_UP, stopGettingValues, false, 0, true);
		}
		
		private function stopGettingValues(e:MouseEvent):void 
		{
			_console.view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, getValues);
			_console.view.stage.removeEventListener(MouseEvent.MOUSE_UP, stopGettingValues);
		}
		
		private function setTopLeft(x:Number, y:Number):void {
			var prevX:Number = _rect.x;
			var prevY:Number = _rect.y;
			_rect.x = x;
			_rect.y = y;	
			checkSnap();
			var diffX:Number = prevX - _rect.x;
			var diffY:Number = prevY - _rect.y;
			_rect.width += diffX;
			_rect.height += diffY;
			_rect.width = Math.max(0, _rect.width);
			_rect.height = Math.max(0, _rect.height);
			keepOnStage();
			render();
		}
		private function setBotRight(x:Number, y:Number):void {
			if (x < _rect.x) _rect.x = x;
			if (y < _rect.y) _rect.y = y;
			_rect.width = x - _rect.x;
			_rect.height = y - _rect.y;
			checkSnap();
			keepOnStage();
			render();
		}
		private function setCenter(x:Number, y:Number):void {
			_rect.x = x-clickOffset.x;
			_rect.y = y-clickOffset.y;	
			checkSnap();
			keepOnStage();
			render();
		}
		
		private function keepOnStage():void
		{
			_rect.x = Math.max(0, Math.min(_rect.x,_console.view.stage.stageWidth-_rect.width));
			_rect.y = Math.max(0, Math.min(_rect.y,_console.view.stage.stageHeight-_rect.height));
		}
		
		private function checkSnap():void
		{
			if (increment > 0) {
				_rect.x = roundTo(_rect.x, increment);
				_rect.y = roundTo(_rect.y, increment);
				_rect.width = roundTo(_rect.width, increment);
				_rect.height= roundTo(_rect.height, increment);
			}
		}
		private function getValues(e:Event = null):void
		{
			var mx:Number = Math.max(0, Math.min(_console.view.stage.mouseX, _console.view.stage.stageWidth));
			var my:Number = Math.max(0, Math.min(_console.view.stage.mouseY, _console.view.stage.stageHeight));
			increment = 1
			var snap:Boolean = false;
			if (e is MouseEvent) {
				var me:MouseEvent = e as MouseEvent
				if (me.shiftKey) {
					increment = 10;
				}else {
					increment = 1;
				}
				snap = me.ctrlKey;
				try { 
					me.updateAfterEvent();
				}catch (err:Error) { };
			}
			
			if (snap) {
				var snapTarget:Rectangle = null;
				var objects:Array = _console.view.stage.getObjectsUnderPoint(new Point(mx, my));
				var dispObj:DisplayObject;
				for (var i:int = objects.length; i--; ) 
				{
					dispObj = objects[i];
					if (!contains(dispObj)) {
						snapTarget = dispObj.getRect(_console.view.stage);
						if(dispObj!=_previousObj){
							if (_selectMode) {
								_scopeManager.setScope(dispObj);
							}else {
								_console.print("Measure tool bracketing: " + dispObj.name + ":" + dispObj);
							}
							_previousObj = dispObj;
						}
						break;
					}
				}
				if (snapTarget) {
					switch(_currentlyChecking) {
						case _topLeftCornerHandle:
						setTopLeft(snapTarget.x, snapTarget.y);
						break;
						case _bottomRightCornerHandle:
						setBotRight(snapTarget.x+snapTarget.width,snapTarget.y+snapTarget.height);
						break;
						case _rectSprite:
						setTopLeft(snapTarget.x, snapTarget.y);
						setBotRight(snapTarget.x + snapTarget.width, snapTarget.y + snapTarget.height);
						break;
					}
				}else {
					switch(_currentlyChecking) {
						case _topLeftCornerHandle:
						setTopLeft(mx, my);
						break;
						case _bottomRightCornerHandle:
						setBotRight(mx,my);
						break;
						case _rectSprite:
						setCenter(mx, my);
						break;
					}
				}
			}else {
				_previousObj = null;
				switch(_currentlyChecking) {
					case _topLeftCornerHandle:
					setTopLeft(mx, my);
					break;
					case _bottomRightCornerHandle:
					setBotRight(mx,my);
					break;
					case _rectSprite:
					setCenter(mx, my);
					break;
				}
			}
			
			render(me.altKey);
		}
		/**
		 * sets x/y and width to the specified display object
		 * @param	displayObject
		 */
		public function bracket(displayObject:DisplayObject):void {
			_console.print("Measure tool bracketing: " + displayObject.name + ":" + typeof(displayObject));
			visible = true;
			_rect = displayObject.getRect(this);
			render();
			_console.print("Measure tool bracketing: " + displayObject.name + ":" + typeof(displayObject));
		}
		public function getMeasurements():String {
			return _rect.toString();
		}
		private function render(local:Boolean = false):void
		{
			_rectSprite.graphics.clear();
			_rectSprite.graphics.beginFill(0, 0.2);
			_rectSprite.graphics.lineStyle(0, 0xFF0000);
			_rectSprite.graphics.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
				
			_bottomRightCornerHandle.x = _rect.x + _rect.width;
			_bottomRightCornerHandle.y = _rect.y + _rect.height;
			_topLeftCornerHandle.x = _rect.x;
			_topLeftCornerHandle.y = _rect.y;
			
			
			var p:Point = new Point(_rect.x, _rect.y);
			if (_currentSpace&&local) {
				p = _currentSpace.globalToLocal(p);
			}
			_xyField.text = "x:" + p.x + " y:" + p.y;
			
			_xyField.x = _rect.x+5;
			_xyField.y = _rect.y - 14;
			_heightField.text = String(_rect.height);
			_heightField.x = _rect.x+_rect.width;
			_heightField.y = _rect.y + _rect.height / 2-_heightField.textHeight/2;
			
			_widthField.text = String(_rect.width);
			_widthField.x = _rect.x+_rect.width/2-_widthField.textWidth/2;
			_widthField.y = _rect.y + _rect.height;
			
		}
		
		public function get increment():Number { return _increment; }
		
		public function set increment(value:Number):void 
		{
			_increment = value; 
			checkSnap();
		}
		
		public function toggle():void
		{
			visible = !visible;
		}
		override public function get visible():Boolean { return super.visible; }
		
		override public function set visible(value:Boolean):void 
		{
			super.visible = value;
			
			if(visible){
				_console.print("Measuring bracket active", ConsoleMessageTypes.SYSTEM);
				_console.print("	Hold shift to round to values of 10", ConsoleMessageTypes.SYSTEM);
				_console.print("	Hold ctrl to snap to mouse target", ConsoleMessageTypes.SYSTEM);
				_console.print("	Hold alt to display coordinates local to current scope (if it is a DisplayObject)", ConsoleMessageTypes.SYSTEM);
			}else {
				_previousObj = null;
				_currentSpace = null;
			}
		}
		private function startMeasure(selectMode:Boolean = false):void
		{
			if(_scopeManager.currentScope.targetObject is DisplayObject){
				invoke(selectMode, _scopeManager.currentScope.targetObject as DisplayObject);
			}else {
				invoke(selectMode, _console.view.stage);
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void
		{
			_console = pm.console;
			_scopeManager = pm.scopeManager;
			pm.messaging.addCallback(Notifications.CONSOLE_SHOW, onVisible);
			_console.createCommand("measure", startMeasure, "Measurements", "Toggles a scalable measurement bracket and selection widget. If X is true, bracketing an object sets it as scope.");
			pm.botLayer.addChild(this);
		}
		
		
		public function shutdown(pm:PluginManager):void
		{
			pm.botLayer.removeChild(this);
			_console.removeCommand("measure");
			pm.messaging.removeCallback(Notifications.CONSOLE_SHOW, onVisible);
			_console = null;
			_scopeManager = null;
		}
		
		public function get descriptionText():String
		{
			return "Enables a scalable, snapping measurement bracket for accurate pixel measurements";
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}
	
}
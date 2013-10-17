package com.furusystems.dconsole2.core.inspector
{
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.inspector.buttons.ModeSelector;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.IDConsoleInspectorPlugin;
	import com.furusystems.dconsole2.core.style.Alphas;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	public class Inspector extends Sprite implements IContainable,IThemeable
	{
		private var posClicked:Point;
		private var dragging:Boolean;
		private var vScrollBar:Shape, hScrollBar:Shape;
		private var _modeSelector:ModeSelector;
		private var _dims:Rectangle;
		private var _currentView:AbstractInspectorView;
		private var prevPos:Point = new Point();
		private var _viewContainer:Sprite = new Sprite;
		private var _enabled:Boolean = true;
		private var _views:Vector.<AbstractInspectorView> = new Vector.<AbstractInspectorView>();
		private var _messaging:PimpCentral;
		public function Inspector(console:IConsole, dims:Rectangle)
		{
			_messaging = console.messaging;
			_dims = dims;
			graphics.clear();
			graphics.beginFill(Colors.INSPECTOR_BG);
			graphics.drawRect(0, 0, dims.width, dims.height);
			
			_modeSelector = new ModeSelector(console);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			vScrollBar = new Shape();
			hScrollBar = new Shape();
			vScrollBar.blendMode = hScrollBar.blendMode = BlendMode.INVERT;
			_viewContainer.y = vScrollBar.y = hScrollBar.y = GUIUnits.SQUARE_UNIT;
			vScrollBar.visible = hScrollBar.visible = false;
			
			addChild(_viewContainer);
			addChild(_modeSelector);
			addChild(vScrollBar);
			addChild(hScrollBar);
			_messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			_messaging.addCallback(Notifications.INSPECTOR_MODE_CHANGE, onModeChanged);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		public function addView(v:IDConsoleInspectorPlugin):void {
			v.associateWithInspector(this);
			_viewContainer.addChild(v.view);
			_modeSelector.addOption(v);
			_views.push(v.view);
			setCurrentView(v.view);
			v.view.resize();
			_messaging.send(Notifications.INSPECTOR_VIEW_ADDED, v, this);
		}
		
		public function setCurrentView(v:AbstractInspectorView):void
		{
			_modeSelector.setCurrentMode(v);
		}
		public function removeView(v:IDConsoleInspectorPlugin):void {
			if (_viewContainer.contains(v.view)) {
				_viewContainer.removeChild(v.view);
				_modeSelector.removeButton(v);
				_views.splice(_views.indexOf(v.view), 1);
				if (v.view == _currentView) {
					if(viewsAdded) setCurrentView(_views[0]);
				}
			}
			_messaging.send(Notifications.INSPECTOR_VIEW_REMOVED, v, this);
			//TODO: Test. This will cause SOME damn issue.
		}
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//tv.populate(stage);
		}
		public function onFrameUpdate(e:Event = null):void {
			if (_currentView && _enabled) {
				_currentView.onFrameUpdate(e);
			}
		}
		
		private function onModeChanged(md:MessageData):void
		{
			if (_currentView == md.data) return;
			if (_currentView) _viewContainer.removeChild(_currentView);
			_currentView = md.data as AbstractInspectorView;
			_viewContainer.addChild(_currentView);
		}
		private function renderBars():void
		{
			vScrollBar.graphics.clear();
			hScrollBar.graphics.clear();
			if (_currentView.scrollYEnabled) {
				var y:Number = _currentView.scrollY / _currentView.maxScrollY * (_dims.height - 6);
				vScrollBar.graphics.beginFill(Colors.SCROLLBAR_FG);
				vScrollBar.graphics.drawRect(_dims.width-3, y, 3, 3);
			}
			if (_currentView.scrollXEnabled) {
				var x:Number = _currentView.scrollX / _currentView.maxScrollX * (_dims.width-3);
				hScrollBar.graphics.beginFill(Colors.SCROLLBAR_FG);
				hScrollBar.graphics.drawRect(x, _dims.height - 16, 3, 3);
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
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
		
		public function onParentUpdate(allotedRect:Rectangle):void
		{
			var rect:Rectangle = allotedRect.clone();
			x = rect.x;
			y = rect.y;
			rect.x = rect.y = 0;
			scrollRect = rect;
			dims = rect;
			drawBackground();
		}
		
		private function drawBackground():void
		{
			graphics.clear();
			graphics.beginFill(Colors.INSPECTOR_BG, Alphas.INSPECTOR_ALPHA);
			graphics.drawRect(0, 0, _dims.width, _dims.height);
			graphics.endFill();
		}
		
		public function get dims():Rectangle { return _dims; }
		
		public function set dims(value:Rectangle):void
		{
			_dims = value;
			for (var i:int = 0; i < _views.length; i++)
			{
				_views[i].resize();
			}
		}
		public function get viewsAdded():Boolean {
			return _views.length > 0;
		}
		public function get enabled():Boolean { return _enabled&&_views.length>0; }
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (dragging) {
				_currentView.stopDragging();
			}
			dragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			vScrollBar.visible = hScrollBar.visible = false;
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			if (!_currentView) return;
			posClicked = new Point(mouseX, mouseY);
			if (posClicked.y <= GUIUnits.SQUARE_UNIT) return;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			prevPos.x = mouseX;
			prevPos.y = mouseY;
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (Point.distance(new Point(mouseX, mouseY), posClicked) > 5) {
				beginDragging();
			}
			var deltaX:Number = mouseX - prevPos.x;
			var deltaY:Number = mouseY - prevPos.y;
			if (dragging) {
				if (e.shiftKey) {
					_currentView.scrollByDelta(deltaX*2, deltaY*2);
				}else {
					_currentView.scrollByDelta(deltaX, deltaY);
				}
				renderBars();
			}
			prevPos.x = mouseX;
			prevPos.y = mouseY;
		}
		
		private function beginDragging():void
		{
			vScrollBar.visible = hScrollBar.visible = true;
			dragging = true;
			_currentView.beginDragging();
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData):void
		{
			drawBackground();
		}
		
	}

}
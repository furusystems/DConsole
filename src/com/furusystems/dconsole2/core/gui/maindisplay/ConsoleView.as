package com.furusystems.dconsole2.core.gui.maindisplay {
	//{
	import com.furusystems.dconsole2.core.animation.ConsoleTweener;
	import com.furusystems.dconsole2.core.animation.EasingTween;
	import com.furusystems.dconsole2.core.effects.Filters;
	import com.furusystems.dconsole2.core.gui.DockingGuides;
	import com.furusystems.dconsole2.core.gui.layout.HorizontalSplit;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.gui.layout.ILayoutContainer;
	import com.furusystems.dconsole2.core.gui.maindisplay.assistant.Assistant;
	import com.furusystems.dconsole2.core.gui.maindisplay.filtertabrow.FilterTabRow;
	import com.furusystems.dconsole2.core.gui.maindisplay.input.InputField;
	import com.furusystems.dconsole2.core.gui.maindisplay.output.OutputField;
	import com.furusystems.dconsole2.core.gui.maindisplay.sections.HeaderSection;
	import com.furusystems.dconsole2.core.gui.maindisplay.sections.InspectorSection;
	import com.furusystems.dconsole2.core.gui.maindisplay.sections.MainSection;
	import com.furusystems.dconsole2.core.gui.maindisplay.toolbar.ConsoleToolbar;
	import com.furusystems.dconsole2.core.gui.ScaleHandle;
	import com.furusystems.dconsole2.core.inspector.Inspector;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	//}
	/**
	 * Root level of the console main view
	 * @author Andreas Roenning
	 */
	public class ConsoleView extends Sprite implements IContainable, ILayoutContainer {
		static public const SHOW_TIME:Number = 0.4;
		private var _console:DConsole;
		private var _rect:Rectangle;
		
		private var _mainSection:MainSection; //section containing main console io
		private var _inspectorSection:InspectorSection; //section containing display list inspector
		private var _headerSection:HeaderSection; //section containing toolbar
		private var _children:Array = [];
		private var _mainSplit:HorizontalSplit;
		private var _mainSplitDragBar:Sprite;
		private var _mainSplitClickOffset:Number;
		private var _mainSplitToggled:Boolean;
		private var _inspector:Inspector;
		private var _isDragging:Boolean;
		
		private var _scalePreview:Shape = new Shape();
		private var _tempScaleRect:Rectangle = new Rectangle();
		private var _prevSplitPos:int = -1;
		private var _texture:BitmapData;
		private var _bg:Sprite = new Sprite();
		private var _inspectorVisible:Boolean = false;
		
		private var _scaleHandle:ScaleHandle;
		
		private var _prevRect:Rectangle = null;
		private var _firstRun:Boolean;
		
		public function get input():InputField {
			return _mainSection.input;
		}
		;
		
		public function get output():OutputField {
			return _mainSection.output;
		}
		;
		
		public function get filtertabs():FilterTabRow {
			return _mainSection.filterTabs;
		}
		;
		
		public function get assistant():Assistant {
			return _mainSection.assistant;
		}
		;
		
		public function get inspector():Inspector {
			return _inspectorSection.inspector;
		}
		;
		
		public function get toolbar():ConsoleToolbar {
			return _headerSection.toolBar;
		}
		;
		
		public function get scaleHandle():ScaleHandle {
			return _scaleHandle;
		}
		;
		
		public function ConsoleView(console:DConsole = null) {
			_scaleHandle = new ScaleHandle(console);
			visible = false;
			
			_console = console;
			
			_texture = new BitmapData(3, 3, true, 0);
			_texture.setPixel32(0, 0, 0xCC000000);
			
			tabEnabled = tabChildren = false;
			_mainSection = new MainSection(console);
			_inspectorSection = new InspectorSection(console);
			_headerSection = new HeaderSection(console);
			
			addChild(_bg);
			addChild(_headerSection);
			
			_mainSplitDragBar = new Sprite();
			_mainSplit = new HorizontalSplit();
			_mainSplit.leftCell.addChild(_inspectorSection);
			_mainSplit.rightCell.addChild(_mainSection);
			_mainSplitDragBar.alpha = 0;
			_mainSplit.splitRatio = 0.2;
			
			addChild(_mainSplit);
			addChild(_mainSplitDragBar);
			addChild(_scaleHandle);
			
			_mainSplitDragBar.addEventListener(MouseEvent.MOUSE_DOWN, beginMainSplitDrag);
			_mainSplitDragBar.addEventListener(MouseEvent.MOUSE_OVER, onMainsplitMouseOver);
			_mainSplitDragBar.addEventListener(MouseEvent.MOUSE_OUT, onMainsplitMouseOut);
			_mainSplitDragBar.addEventListener(MouseEvent.DOUBLE_CLICK, toggleMainSplit);
			_mainSplitDragBar.doubleClickEnabled = true;
			_mainSplitDragBar.buttonMode = true;
			
			scaleHandle.addEventListener(MouseEvent.MOUSE_DOWN, beginScaleDrag);
			scaleHandle.addEventListener(MouseEvent.DOUBLE_CLICK, onScaleDoubleclick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			tabEnabled = tabChildren = false;
			
			_console.messaging.addCallback(Notifications.INSPECTOR_VIEW_REMOVED, onInspectorViewCountChange);
			_console.messaging.addCallback(Notifications.INSPECTOR_VIEW_ADDED, onInspectorViewCountChange);
			
			_console.messaging.addCallback(Notifications.TOOLBAR_DRAG_START, onToolbarDrag);
			_console.messaging.addCallback(Notifications.TOOLBAR_DRAG_STOP, onToolbarDrag);
			_console.messaging.addCallback(Notifications.TOOLBAR_DRAG_UPDATE, onToolbarDrag);
			
			_console.messaging.addCallback(Notifications.CORNER_DRAG_START, onCornerScale);
			_console.messaging.addCallback(Notifications.CORNER_DRAG_STOP, onCornerScale);
			_console.messaging.addCallback(Notifications.CORNER_DRAG_UPDATE, onCornerScale);
			
			//setupBloom();
			//addChild(bloom);
		}
		
		private function setupBloom():void {
			addEventListener(Event.ENTER_FRAME, updateBloom);
			scanlinePattern.setPixel32(0, 0, 0xFF808080);
			scanlinePattern.setPixel32(0, 1, 0xFFeeeeee);
		}
		
		public function toggleBloom():void {
			bloomEnabled = !bloomEnabled;
			if (!bloomEnabled) {
				if (contains(bloom))
					removeChild(bloom);
				if (contains(scanlines))
					removeChild(scanlines);
			}
		}
		
		private function onCornerScale(md:MessageData):void {
			switch (md.message) {
				case Notifications.CORNER_DRAG_START:
					Mouse.cursor = MouseCursor.HAND;
					break;
				case Notifications.CORNER_DRAG_STOP:
					Mouse.cursor = MouseCursor.AUTO;
					break;
				case Notifications.CORNER_DRAG_UPDATE:
					_tempScaleRect.height = Math.round(Math.max(GUIUnits.SQUARE_UNIT * 5, Math.min(stage.stageHeight - GUIUnits.SQUARE_UNIT, (stage.mouseY - y))) / GUIUnits.SQUARE_UNIT) * GUIUnits.SQUARE_UNIT; //TODO: This is messy as hell!
					_tempScaleRect.width = stage.mouseX - x;
					var r:Rectangle = rect;
					r.height = _tempScaleRect.height;
					r.width = _tempScaleRect.width;
					r.width = Math.ceil(Math.max(150, Math.min(r.width, stage.stageWidth - x)));
					rect = r;
					break;
			}
		}
		
		override public function get x():Number {
			return super.x;
		}
		
		override public function set x(value:Number):void {
			if (super.x == value) return;
			super.x = _console.persistence.consoleX = value;
		}
		
		override public function get y():Number {
			return super.y;
		}
		
		override public function set y(value:Number):void {
			if (super.y == value) return;
			super.y = _console.persistence.consoleY = value;
		}
		
		override public function get height():Number {
			return _console.persistence.consoleHeight;
		}
		
		override public function set height(value:Number):void {
			_console.persistence.consoleHeight = value;
			rect = _console.persistence.rect;
		}
		
		override public function get width():Number {
			return _console.persistence.consoleWidth;
		}
		
		override public function set width(value:Number):void {
			_console.persistence.consoleWidth = value;
			rect = _console.persistence.rect;
		}
		
		private function onToolbarDrag(md:MessageData):void {
			switch (md.message) {
				case Notifications.TOOLBAR_DRAG_START:
					Mouse.cursor = MouseCursor.HAND;
					break;
				case Notifications.TOOLBAR_DRAG_STOP:
					Mouse.cursor = MouseCursor.AUTO;
					_console.messaging.send(Notifications.HIDE_DOCKING_GUIDE, null, this);
					updateDocking();
					break;
				case Notifications.TOOLBAR_DRAG_UPDATE:
					x += md.data.x;
					y += md.data.y;
					x = int(Math.max(0, Math.min(x, stage.stageWidth - _rect.width)));
					y = int(Math.max(0, Math.min(y, stage.stageHeight - _rect.height)));
					
					scaleHandle.visible = true;
					if (y <= 2) {
						_console.messaging.send(Notifications.SHOW_DOCKING_GUIDE, DockingGuides.TOP, this);
						_console.persistence.dockState.value = DConsole.DOCK_TOP;
						_scaleHandle.y = _rect.height;
					} else if (y >= stage.stageHeight - _rect.height - 2) {
						_console.messaging.send(Notifications.SHOW_DOCKING_GUIDE, DockingGuides.BOT, this);
						_console.persistence.dockState.value = DConsole.DOCK_BOT;
						_scaleHandle.y = -scaleHandle.height;
					} else {
						_console.messaging.send(Notifications.HIDE_DOCKING_GUIDE, null, this);
						_console.persistence.dockState.value = DConsole.DOCK_WINDOWED;
						scaleHandle.visible = false;
					}
					assistant.cornerHandle.visible = !scaleHandle.visible;
					break;
			}
		}
		
		private function onInspectorViewCountChange(md:MessageData):void {
			_mainSplit.splitRatio = _console.persistence.verticalSplitRatio.value;
			doLayout();
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_firstRun = true;
			initFromPersistence();
			switch (dockingMode) {
				case DConsole.DOCK_BOT:
					y = stage.stageHeight + 10;
					break;
				case DConsole.DOCK_TOP:
					y = -height;
					break;
			}
			onParentUpdate(_rect);
			_firstRun = false;
		}
		
		private function initFromPersistence():void {
			_mainSplit.splitRatio = _console.persistence.verticalSplitRatio.value;
			inspector.enabled = _mainSplit.splitRatio > 0;
			rect = _console.persistence.rect;
			x = _console.persistence.consoleX;
			y = _console.persistence.consoleY;
		}
		
		public function get splitRatio():Number {
			return _mainSplit.splitRatio;
		}
		
		public function set splitRatio(n:Number):void {
			_mainSplit.splitRatio = n;
		}
		
		private function onScaleDoubleclick(e:MouseEvent):void {
			var r:Rectangle = rect;
			if (r.height < 50) {
				r.height = stage.stageHeight * .8;
			} else {
				r.height = 0;
			}
			rect = r;
		}
		
		private function beginScaleDrag(e:MouseEvent):void {
			Mouse.cursor = MouseCursor.HAND;
			scaleHandle.dragging = true;
			_scalePreview.visible = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onScaleUpdate);
			stage.addEventListener(MouseEvent.MOUSE_UP, completeScale);
			onScaleUpdate(e);
		}
		
		private function completeScale(e:MouseEvent):void {
			Mouse.cursor = MouseCursor.AUTO;
			scaleHandle.dragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onScaleUpdate);
			stage.removeEventListener(MouseEvent.MOUSE_UP, completeScale);
			doLayout();
		}
		
		private function onScaleUpdate(e:MouseEvent):void {
			Mouse.cursor = MouseCursor.HAND;
			var r:Rectangle = rect;
			switch (dockingMode) {
				case DConsole.DOCK_BOT:
					_tempScaleRect.height = Math.round(Math.max(GUIUnits.SQUARE_UNIT * 1, Math.min(stage.stageHeight - GUIUnits.SQUARE_UNIT, stage.stageHeight - stage.mouseY - 8)) / GUIUnits.SQUARE_UNIT) * GUIUnits.SQUARE_UNIT;
					if (r.height != _tempScaleRect.height) {
						r.height = height = _tempScaleRect.height;
						rect = r;
						y = stage.stageHeight - r.height;
					}
					break;
				default:
					_tempScaleRect.height = Math.round(Math.max(GUIUnits.SQUARE_UNIT * 1, Math.min(stage.stageHeight - GUIUnits.SQUARE_UNIT, stage.mouseY - 8)) / GUIUnits.SQUARE_UNIT) * GUIUnits.SQUARE_UNIT;
					if (r.height != _tempScaleRect.height) {
						r.height = height = _tempScaleRect.height;
						rect = r;
					}
			}
		}
		
		private function showInspector():void {
			if (!_inspectorVisible || _firstRun) {
				_mainSplit.setSplitPos(_prevSplitPos);
				_inspectorVisible = true;
				inspector.enabled = _prevSplitPos > 0;
			}
		}
		
		private function hideInspector():void {
			if (_inspectorVisible || _firstRun) {
				_inspectorVisible = inspector.enabled = false;
				_prevSplitPos = _mainSplit.getSplitPos();
				_mainSplit.setSplitPos(0);
			}
		}
		
		public function setHeaderText(text:String):void {
			_headerSection.toolBar.setTitle(text);
		}
		
		private function doLayout():void {
			if (_prevRect) {
				if (_prevRect.equals(_rect)) return;
			}
			var r:Rectangle = _rect.clone();
			_headerSection.onParentUpdate(r);
			if (_headerSection.visible) {
				r.y = GUIUnits.SQUARE_UNIT;
				r.height -= GUIUnits.SQUARE_UNIT;
			} else { //if there is no header, move us up a spot
			}
			_mainSplit.rect = r;
			_mainSplitDragBar.graphics.clear();
			if (rect.height < 128 || !inspector.viewsAdded) {
				hideInspector();
				_mainSplit.setSplitPos(0);
			} else {
				showInspector();
				_mainSplitDragBar.graphics.beginFill(0, 0.1);
				_mainSplitDragBar.graphics.drawRect(0, 0, 8, r.height);
				_mainSplitDragBar.x = int(_mainSplit.splitRatio * r.width - 4);
				_mainSplitDragBar.y = _mainSplit.y;
			}
			r.height = GUIUnits.SQUARE_UNIT;
			
			switch (dockingMode) {
				case DConsole.DOCK_BOT:
					r.y = -scaleHandle.height;
					scaleHandle.onParentUpdate(r);
					break;
				default:
					r.y = _rect.height;
					scaleHandle.onParentUpdate(r);
					break;
			}
			
			_prevRect = r.clone();
		}
		
		private function onMainsplitMouseOut(e:MouseEvent):void {
			if (_isDragging)
				return;
			_mainSplitDragBar.alpha = 0;
			_mainSplitDragBar.blendMode = BlendMode.NORMAL;
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function onMainsplitMouseOver(e:MouseEvent):void {
			if (_isDragging)
				return;
			_mainSplitDragBar.alpha = 1;
			_mainSplitDragBar.blendMode = BlendMode.INVERT;
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function toggleMainSplit(e:MouseEvent):void {
			if (_mainSplit.getSplitPos() > 30) {
				_inspectorVisible = false;
				_prevSplitPos = _mainSplit.getSplitPos();
				_mainSplit.setSplitPos(0);
				hideInspector();
			} else {
				_inspectorVisible = true;
				_mainSplit.setSplitPos(_prevSplitPos = 300);
				showInspector();
			}
			doLayout();
		}
		
		private function beginMainSplitDrag(e:MouseEvent):void {
			_isDragging = true;
			_mainSplitDragBar.alpha = 1;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, updateMainSplitDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopMainSplitDrag);
		}
		
		private function stopMainSplitDrag(e:MouseEvent):void {
			_isDragging = false;
			_mainSplitDragBar.alpha = 0;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateMainSplitDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopMainSplitDrag);
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function updateMainSplitDrag(e:MouseEvent):void {
			Mouse.cursor = MouseCursor.HAND;
			var p:int = Math.max(0, Math.min(_rect.width / 2, mouseX));
			if (p < 30)
				p = 0;
			
			inspector.enabled = p > 0;
			_mainSplit.setSplitPos(p);
			
			_console.persistence.verticalSplitRatio.value = _mainSplit.splitRatio;
			doLayout();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			children.push(child);
			return super.addChild(child);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle):void {
			allotedRect.height = Math.floor(allotedRect.height);
			allotedRect.width = Math.round(allotedRect.width);
			rect = allotedRect;
		}
		
		public function show():void {
			visible = output.visible = true;
			switch (dockingMode) {
				case DConsole.DOCK_WINDOWED:
					onShown();
					break;
				case DConsole.DOCK_BOT:
					ConsoleTweener.tween(this, "y", stage.stageHeight - height, SHOW_TIME, onShown, EasingTween);
					break;
				case DConsole.DOCK_TOP:
				default:
					ConsoleTweener.tween(this, "y", 0, SHOW_TIME, onShown, EasingTween);
					break;
			}
		}
		
		private function onShown():void {
			_console.messaging.send(Notifications.CONSOLE_VIEW_TRANSITION_COMPLETE, true);
		}
		
		public function hide():void {
			
			if (!stage) {
				onHidden();
				return;
			}
			switch (dockingMode) {
				case DConsole.DOCK_WINDOWED:
					onHidden();
					break;
				case DConsole.DOCK_BOT:
					ConsoleTweener.tween(this, "y", stage.stageHeight + 10, SHOW_TIME, onHidden, EasingTween);
					break;
				case DConsole.DOCK_TOP:
				default:
					ConsoleTweener.tween(this, "y", -height, SHOW_TIME, onHidden, EasingTween);
					break;
			}
		}
		
		public function maximize():void {
			var r:Rectangle;
			switch (dockingMode) {
				case DConsole.DOCK_WINDOWED:
					dockingMode = DConsole.DOCK_TOP;
					maximize();
					break;
				default:
					r = _rect;
					r.height = int(stage.stageHeight - GUIUnits.SQUARE_UNIT);
					r.width = int(stage.stageWidth);
					rect = r;
					updateDocking();
					output.drawMessages();
					break;
			}
		}
		
		public function minimize():void {
			var r:Rectangle = _rect;
			switch (dockingMode) {
				case DConsole.DOCK_WINDOWED:
					r.height = 5 * GUIUnits.SQUARE_UNIT;
					rect = r;
					break;
				default:
					r.height = GUIUnits.SQUARE_UNIT;
					//r.width = stage.stageWidth;
					updateDocking();
					rect = r;
			}
			output.drawMessages();
		}
		
		public function consolidateView():void {
			var r:Rectangle = _console.persistence.rect;
			x = r.x;
			y = r.y;
			width = r.width;
			height = r.height;
			updateDocking();
		}
		
		private function onHidden():void {
			visible = output.visible = false;
			_console.messaging.send(Notifications.CONSOLE_VIEW_TRANSITION_COMPLETE, false);
		}
		
		public function get children():Array {
			return _children;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.ILayoutContainer */
		
		public function set rect(r:Rectangle):void {
			//if (_rect) {
				//if (_rect.equals(r)) return;
			//}
			_rect = r;
			_rect.x = _rect.y = 0;
			_rect.height = Math.floor(Math.max(minHeight, _rect.height) / GUIUnits.SQUARE_UNIT) * GUIUnits.SQUARE_UNIT;
			_rect.width = int(Math.max(minWidth, _rect.width));
			_bg.graphics.clear();
			_bg.graphics.lineStyle(0, Colors.CORE);
			//_bg.graphics.beginBitmapFill(_texture, null, true);
			_bg.graphics.drawRect(0, 0, _rect.width, _rect.height);
			_bg.graphics.endFill();
			//scrollRect = _rect;
			
			_console.persistence.consoleWidth = _rect.width;
			_console.persistence.consoleHeight = _rect.height;
			doLayout();
		}
		
		public function get rect():Rectangle {
			return _console.persistence.rect;
		}
		
		public function get minHeight():Number {
			return 32;
		}
		
		public function get minWidth():Number {
			return 0;
		}
		
		public function get mainSection():MainSection {
			return _mainSection;
		}
		
		public function get dockingMode():int {
			return _console.persistence.dockState.value;
		}
		
		public function set dockingMode(value:int):void {
			_console.persistence.dockState.value = value;
			updateDocking();
		}
		
		private function updateDocking():void {
			scaleHandle.visible = true;
			switch (dockingMode) {
				case DConsole.DOCK_TOP:
					_rect.width = stage.stageWidth;
					rect = _rect;
					x = 0;
					y = 0;
					break;
				case DConsole.DOCK_BOT:
					_rect.width = stage.stageWidth;
					_scaleHandle.y = -scaleHandle.height;
					rect = _rect;
					y = stage.stageHeight - _rect.height;
					x = 0;
					break;
				case DConsole.DOCK_WINDOWED:
					rect = _rect;
					scaleHandle.visible = false;
					break;
			}
			assistant.cornerHandle.visible = !scaleHandle.visible;
		}
		
		private var bloomBmp:BitmapData;
		private var bloom:Bitmap = new Bitmap();
		private var scanlines:Shape = new Shape();
		private var scanlinePattern:BitmapData = new BitmapData(1, 3, true, 0);
		private var bloomEnabled:Boolean = false;
		
		private function updateBloom(e:Event = null):void {
			if (!bloomEnabled)
				return;
			scanlines.graphics.clear();
			scanlines.graphics.beginBitmapFill(scanlinePattern, null, true, false);
			scanlines.graphics.drawRect(0, 0, output.width, output.height);
			scanlines.graphics.endFill();
			scanlines.blendMode = BlendMode.MULTIPLY;
			if (bloomBmp) {
				bloomBmp.dispose();
			}
			if (contains(bloom))
				removeChild(bloom);
			if (contains(scanlines))
				removeChild(scanlines);
			bloom.blendMode = BlendMode.ADD;
			bloomBmp = new BitmapData(output.width, output.height, true, 0);
			bloomBmp.lock();
			bloomBmp.draw(output);
			
			bloomBmp.applyFilter(bloomBmp, bloomBmp.rect, new Point(), new BlurFilter(16, 16, 1));
			bloomBmp.applyFilter(bloomBmp, bloomBmp.rect, new Point(), new BlurFilter(16, 16, 1));
			bloomBmp.colorTransform(bloomBmp.rect, new ColorTransform(1, 2, 1));
			bloomBmp.unlock();
			bloom.bitmapData = bloomBmp;
			
			addChild(bloom);
			addChild(scanlines);
			
			var p:Point = new Point(output.x, output.y);
			p = output.parent.localToGlobal(p);
			bloom.x = scanlines.x = p.x - x;
			bloom.y = scanlines.y = p.y - y
		}
	}

}
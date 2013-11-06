package com.furusystems.dconsole2.core.gui {
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class Window extends Sprite {
		public static const BAR_HEIGHT:int = 12;
		public static const SCALE_HANDLE_SIZE:int = 10;
		private static const GRADIENT_MATRIX:Matrix = new Matrix();
		private var _contents:Sprite = new Sprite();
		private var _chrome:Sprite = new Sprite();
		private var _outlines:Shape = new Shape();
		private var _header:Sprite = new Sprite();
		private var _titleField:TextField = new TextField();
		private var _resizeHandle:Sprite = new Sprite();
		private var _clickOffset:Point = new Point();
		private var _resizeRect:Rectangle = new Rectangle();
		private var _maxRect:Rectangle;
		private var _minRect:Rectangle;
		private var _maxScrollV:Number = 0;
		private var _maxScrollH:Number = 0;
		private var _scrollBarBottom:SimpleScrollbar = new SimpleScrollbar(SimpleScrollbar.HORIZONTAL);
		private var _scrollBarRight:SimpleScrollbar = new SimpleScrollbar(SimpleScrollbar.VERTICAL);
		private var _closeButton:Sprite = new Sprite();
		private var _background:Shape = new Shape();
		public var viewRect:Rectangle;
		private var _constrainToStage:Boolean;
		private var pt:Point = new Point();
		
		public function Window(title:String, rect:Rectangle, contents:DisplayObject = null, maxRect:Rectangle = null, minRect:Rectangle = null, enableClose:Boolean = true, enableScroll:Boolean = true, enableScale:Boolean = true, constrainToStage:Boolean = true) {
			tabEnabled = tabChildren = false;
			_scrollBarBottom.addEventListener(Event.CHANGE, onScroll);
			_scrollBarRight.addEventListener(Event.CHANGE, onScroll);
			
			_closeButton.graphics.beginFill(Colors.BUTTON_INACTIVE_BG);
			_closeButton.graphics.lineStyle(0, 0);
			_closeButton.graphics.drawRect(0, 0, BAR_HEIGHT - 3, BAR_HEIGHT - 3);
			_closeButton.buttonMode = true;
			
			_constrainToStage = constrainToStage;
			
			addChild(_background);
			this._contents.y = _background.y = BAR_HEIGHT;
			addChild(this._contents);
			
			this._maxRect = maxRect;
			this._minRect = minRect;
			
			//rect.height += BAR_HEIGHT;
			_titleField.height = BAR_HEIGHT + 3;
			_titleField.selectable = false;
			_titleField.defaultTextFormat = TextFormats.consoleTitleFormat;
			_titleField.embedFonts = true;
			_titleField.textColor = Colors.HEADER_FG;
			_titleField.text = title;
			_titleField.y -= 2;
			_titleField.mouseEnabled = false;
			
			_resizeHandle.graphics.clear();
			_resizeHandle.graphics.beginFill(Colors.CORE, 0);
			_resizeHandle.graphics.drawRect(0, 0, SCALE_HANDLE_SIZE, SCALE_HANDLE_SIZE);
			_resizeHandle.graphics.endFill();
			_resizeHandle.graphics.lineStyle(0, Colors.CORE);
			_resizeHandle.graphics.moveTo(SCALE_HANDLE_SIZE, 0);
			_resizeHandle.graphics.lineTo(0, SCALE_HANDLE_SIZE);
			_resizeHandle.graphics.moveTo(SCALE_HANDLE_SIZE, 5);
			_resizeHandle.graphics.lineTo(0, SCALE_HANDLE_SIZE + 5);
			_resizeHandle.scrollRect = new Rectangle(0, 0, SCALE_HANDLE_SIZE, SCALE_HANDLE_SIZE);
			_resizeHandle.blendMode = BlendMode.INVERT;
			
			_closeButton.addEventListener(MouseEvent.CLICK, onClose);
			_closeButton.addEventListener(MouseEvent.ROLL_OVER, onCloseRollover);
			_closeButton.addEventListener(MouseEvent.ROLL_OUT, onCloseRollout);
			
			addChild(_chrome);
			
			_header.addChild(_titleField);
			_chrome.addChild(_header);
			
			if (enableScroll) {
				_chrome.addChild(_scrollBarBottom);
				_chrome.addChild(_scrollBarRight);
			}
			if (enableScale)
				_chrome.addChild(_resizeHandle);
			if (enableClose)
				_chrome.addChild(_closeButton);
			_chrome.addChild(_outlines);
			
			_resizeHandle.buttonMode = _header.buttonMode = true;
			
			x = rect.x;
			y = rect.y;
			
			var dsf:DropShadowFilter = new DropShadowFilter(4, 45, 0, .1, 8, 8);
			//filters = [dsf];
			
			redraw(rect);
			
			_header.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			_resizeHandle.addEventListener(MouseEvent.MOUSE_DOWN, startResizing);
			addEventListener(MouseEvent.MOUSE_DOWN, setDepth);
			if (contents) {
				setContents(contents);
			}
		}
		
		public function setViewRect(rect:Rectangle):void {
			redraw(rect);
		}
		
		private function onCloseRollout(e:MouseEvent):void {
			DisplayObject(e.target).blendMode = BlendMode.NORMAL;
		}
		
		private function onCloseRollover(e:MouseEvent):void {
			DisplayObject(e.target).blendMode = BlendMode.INVERT;
		}
		
		protected function setTitle(str:String):void {
			_titleField.text = str;
		}
		
		protected function onClose(e:MouseEvent):void {
			_header.removeEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			_resizeHandle.removeEventListener(MouseEvent.MOUSE_DOWN, startResizing);
			removeEventListener(MouseEvent.MOUSE_DOWN, setDepth);
		}
		
		protected function onScroll(e:Event):void {
			var r:Rectangle = getContentsRect();
			var newRect:Rectangle = _contents.scrollRect.clone();
			switch (e.target) {
				case _scrollBarBottom:
					newRect.x = _scrollBarBottom.outValue * (_maxScrollH - newRect.width);
					break;
				case _scrollBarRight:
					newRect.y = _scrollBarRight.outValue * (_maxScrollV - newRect.height);
					break;
			}
			_contents.scrollRect = newRect;
			redraw(viewRect);
		}
		
		protected function startResizing(e:MouseEvent):void {
			_clickOffset.x = SCALE_HANDLE_SIZE - _resizeHandle.mouseX;
			_clickOffset.y = SCALE_HANDLE_SIZE - _resizeHandle.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onResizeDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, onResizeStop);
		}
		
		protected function onResizeStop(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onResizeDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onResizeStop);
		}
		
		protected function onResizeDrag(e:MouseEvent):void {
			e.updateAfterEvent();
			pt.x = mouseX + _clickOffset.x;
			pt.y = mouseY + _clickOffset.y;
			pt = localToGlobal(pt);
			pt.x = Math.min(stage.stageWidth, pt.x);
			pt.y = Math.min(stage.stageHeight, pt.y);
			pt = globalToLocal(pt);
			
			pt.x = Math.max(SCALE_HANDLE_SIZE + BAR_HEIGHT, pt.x);
			pt.y = Math.max(SCALE_HANDLE_SIZE + BAR_HEIGHT, pt.y);
			
			_resizeRect.width = pt.x;
			_resizeRect.height = pt.y - BAR_HEIGHT;
			_resizeRect.x = x;
			_resizeRect.y = y;
			if (_minRect) {
				_resizeRect.width = Math.max(_minRect.width, _resizeRect.width);
				_resizeRect.height = Math.max(_minRect.height, _resizeRect.height);
			}
			onResize();
			redraw(_resizeRect);
		}
		
		protected function onResize():void {
		
		}
		
		protected function scroll(x:int = 0, y:int = 0):void {
			if (_contents.scrollRect.x + x >= 0) {
				if (_contents.scrollRect.width + x <= _maxScrollH)
					_contents.scrollRect.x += x;
			}
			if (_contents.scrollRect.y + y >= 0) {
				if (_contents.scrollRect.height + y <= _maxScrollV)
					_contents.scrollRect.y += y;
			}
		}
		
		protected function resetScroll():void {
			_contents.scrollRect.x = 0;
			_contents.scrollRect.y = 0;
			_scrollBarBottom.outValue = 0;
			_scrollBarRight.outValue = 0;
		}
		
		public function updateAppearance():void {
			//TODO: Update theme
		}
		
		protected function redraw(rect:Rectangle):void {
			//GRADIENT_MATRIX.createGradientBox(rect.width * 3, rect.height * 3);
			
			_background.graphics.clear();
			_background.graphics.beginFill(Colors.ASSISTANT_BG);
			//_background.graphics.beginGradientFill(GradientType.RADIAL, [Colors.CORE, Colors.DROPDOWN_BG_INACTIVE], [1, 1], [0, 255], GRADIENT_MATRIX);
			_background.graphics.drawRect(0, 0, rect.width, rect.height);
			
			_header.graphics.clear();
			_header.graphics.beginFill(Colors.HEADER_BG);
			_header.graphics.drawRect(0, 0, rect.width, BAR_HEIGHT);
			_header.graphics.endFill();
			
			_outlines.graphics.clear();
			_outlines.graphics.lineStyle(0, 0);
			_outlines.graphics.drawRect(0, 0, rect.width, rect.height + BAR_HEIGHT);
			
			_titleField.width = rect.width;
			_closeButton.x = rect.width - (BAR_HEIGHT - 2);
			_closeButton.y = 1;
			
			_resizeHandle.x = rect.width - SCALE_HANDLE_SIZE;
			_resizeHandle.y = rect.height + BAR_HEIGHT - SCALE_HANDLE_SIZE;
			
			var cRect:Rectangle = getContentsRect();
			
			if (rect.width < cRect.width) {
				_maxScrollH = cRect.width;
			} else {
				_maxScrollH = 0;
			}
			if (rect.height < cRect.height) {
				_maxScrollV = cRect.height;
			} else {
				_maxScrollV = 0;
			}
			_contents.scrollRect = new Rectangle(Math.max(0, _scrollBarBottom.outValue * (_maxScrollH - rect.width)), Math.max(0, _scrollBarRight.outValue * (_maxScrollV - rect.height)), rect.width + 1, rect.height + 1);
			updateScrollBars(_maxScrollH, _maxScrollV, rect);
			viewRect = rect;
			
			x = viewRect.x;
			y = viewRect.y;
		}
		
		protected function updateScrollBars(maxH:Number, maxV:Number, rect:Rectangle):void {
			if (maxH > 0) {
				_scrollBarBottom.visible = true;
				_scrollBarBottom.y = rect.height + BAR_HEIGHT - _scrollBarBottom.trackWidth;
				_scrollBarBottom.draw(rect.width - SCALE_HANDLE_SIZE, _contents.scrollRect, _contents.scrollRect.x, maxH);
			} else {
				_scrollBarBottom.visible = false;
			}
			
			if (maxV > 0) {
				_scrollBarRight.visible = true;
				_scrollBarRight.x = rect.width - _scrollBarRight.trackWidth;
				_scrollBarRight.y = BAR_HEIGHT;
				_scrollBarRight.draw(rect.height - SCALE_HANDLE_SIZE, _contents.scrollRect, _contents.scrollRect.y, maxV);
			} else {
				_scrollBarRight.visible = false;
			}
		}
		
		protected function getContentsRect():Rectangle {
			if (_contents.numChildren < 1)
				return new Rectangle();
			return _contents.getChildAt(0).getRect(_contents);
		}
		
		protected function setDepth(e:MouseEvent):void {
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		protected function startDragging(e:MouseEvent):void {
			_clickOffset.x = _chrome.mouseX;
			_clickOffset.y = _chrome.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onWindowDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}
		
		protected function stopDragging(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onWindowDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}
		
		protected function onWindowDrag(e:MouseEvent):void {
			x = stage.mouseX - _clickOffset.x;
			y = stage.mouseY - _clickOffset.y;
			/*if (_constrainToStage) {
			   x = Math.max(0, Math.min(x, stage.stageWidth - width));
			   y = Math.max(0, Math.min(y, stage.stageHeight - height));
			 }*/
			viewRect.x = x;
			viewRect.y = y;
			//e.updateAfterEvent();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setContents(d:DisplayObject, autoScale:Boolean = false):void {
			while (_contents.numChildren > 0) {
				_contents.removeChildAt(0);
			}
			_contents.addChild(d);
			if (autoScale) {
				scaleToContents();
			}
		}
		
		protected function scaleToContents():void {
			viewRect = getContentsRect();
			redraw(viewRect);
			onResize();
		}
		
		public function get header():Sprite {
			return _header;
		}
	
	}

}
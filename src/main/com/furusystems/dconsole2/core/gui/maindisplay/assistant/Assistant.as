package com.furusystems.dconsole2.core.gui.maindisplay.assistant {
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.strings.Strings;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * The assistant is a line of text following the input field. It displays any relevant tooltips.
	 * @author Andreas Roenning
	 */
	public class Assistant extends Sprite implements IContainable, IThemeable {
		private var _infoField:TextField;
		private var _idle:Boolean = true;
		private var _snapshot:BitmapData;
		private var _snapshotDisplay:Bitmap = new Bitmap();
		private var _time:Number = 0;
		private var _prevTimeUpdate:Number = 0;
		private var _cornerHandle:CornerScaleHandle
		
		public function Assistant(console:IConsole) {
			_cornerHandle = new CornerScaleHandle(console);
			_infoField = new TextField();
			_infoField.background = true;
			_infoField.tabEnabled = false;
			_infoField.embedFonts = TextFormats.INPUT_FONT.charAt(0) != "_";
			_infoField.mouseEnabled = false;
			_infoField.selectable = true;
			//_infoField.y--;
			_infoField.defaultTextFormat = TextFormats.helpTformat;
			addChild(_infoField);
			addChild(_snapshotDisplay);
			//_snapshotDisplay.y--;
			_snapshotDisplay.visible = false;
			//addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); //TODO: Reenable later maybe? Seems really superfluous
			console.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			console.messaging.addCallback(Notifications.ASSISTANT_MESSAGE_REQUEST, onMessageRequest);
			console.messaging.addCallback(Notifications.ASSISTANT_CLEAR_REQUEST, onClearRequest);
			console.messaging.addCallback(Notifications.FRAME_UPDATE, onFrameUpdate);
			_infoField.text = "Assistant";
			
			addChild(_cornerHandle).visible = false;
		}
		
		private function onFrameUpdate(md:MessageData):void {
			if (text == "")
				return;
			if (_infoField.maxScrollH > 0) {
				_time += getTimer() - _prevTimeUpdate;
				_infoField.scrollH = (Math.sin(_time / 1000) + 1) / 2 * _infoField.maxScrollH;
				_prevTimeUpdate = getTimer();
			} else {
				_time = _prevTimeUpdate = 0;
			}
		}
		
		private function onClearRequest(md:MessageData):void {
			clear();
		}
		
		private function onMessageRequest(md:MessageData):void {
			text = md.data.toString();
		}
		
		private function onMouseDown(e:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_snapshot = new BitmapData(_infoField.width, _infoField.height, false, 0);
			_snapshot.draw(_infoField);
			_snapshotDisplay.bitmapData = _snapshot;
			_snapshotDisplay.visible = true;
			_infoField.visible = false;
		}
		
		private function onMouseUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_snapshot.dispose();
			_snapshotDisplay.visible = false;
			_infoField.visible = true;
		}
		
		public function get text():String {
			return _infoField.text;
		}
		
		public function set text(s:String):void {
			_infoField.text = s;
			_infoField.scrollH = 0;
			_time = _prevTimeUpdate = 0;
			_idle = false;
		}
		
		/**
		 * Sets the current text, but doesn't mark the assistant as busy
		 * @param	s
		 */
		public function setWeakText(s:String):void {
			_infoField.text = s;
			_idle = true;
		}
		
		public function clear():void {
			setWeakText(Strings.ASSISTANT_STRINGS.get(Strings.ASSISTANT_STRINGS.DEFAULT_ID));
			//text = "";
			_idle = true;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle):void {
			y = allotedRect.y;
			x = allotedRect.x;
			_infoField.height = GUIUnits.SQUARE_UNIT;
			_infoField.width = allotedRect.width;
			_cornerHandle.x = allotedRect.width - _cornerHandle.width;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData):void {
			_infoField.backgroundColor = Colors.ASSISTANT_BG
			_infoField.textColor = Colors.ASSISTANT_FG;
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
		
		public function get idle():Boolean {
			return _idle;
		}
		
		public function get cornerHandle():CornerScaleHandle {
			return _cornerHandle;
		}
	
	}

}
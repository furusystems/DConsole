package com.furusystems.dconsole2.plugins.controller {
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import com.furusystems.dconsole2.core.style.TextFormats;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ControlField extends Sprite {
		private var tf:TextField;
		public var targetProperty:String;
		public var hasFocus:Boolean;
		
		public function ControlField(property:String, type:String = "string") {
			targetProperty = property;
			tf = new TextField();
			tf.defaultTextFormat = TextFormats.consoleTitleFormat;
			tf.embedFonts = true;
			tf.textColor = 0x333333;
			tf.height = GUIUnits.SQUARE_UNIT;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = true;
			tf.type = TextFieldType.INPUT;
			//tf.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocus);
			tf.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			addChild(tf);
			switch (type.toLowerCase()) {
				case "uint":
					tf.restrict = "0123456789";
					break;
				case "int":
					tf.restrict = "0123456789-";
					break;
				case "number":
					tf.restrict = "0123456789.-";
					break;
			}
			if (type.toLowerCase() != "string")
				tf.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
		}
		
		private function onFocusOut(e:FocusEvent):void {
			hasFocus = false;
			removeEventListener(KeyboardEvent.KEY_DOWN, onEnter);
		}
		
		private function onFocusIn(e:FocusEvent):void {
			hasFocus = true;
			addEventListener(KeyboardEvent.KEY_DOWN, onEnter, false, 0, true);
		}
		
		private function onEnter(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				onTextfieldChange();
			}
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			var d:Number = Math.max(-1, Math.min(1, e.delta));
			var num:Number = Number(tf.text);
			if (e.shiftKey) {
				d *= 0.1;
			}
			if (e.ctrlKey) {
				d *= 0.1;
			}
			num += d;
			tf.text = num.toString();
			onTextfieldChange();
		}
		
		public function get value():* {
			return tf.text;
		}
		
		public function set value(n:*):void {
			tf.text = n.toString();
		}
		
		private function onTextfieldChange(e:Event = null):void {
			dispatchEvent(new ControllerEvent(ControllerEvent.VALUE_CHANGE));
		}
	
	}

}
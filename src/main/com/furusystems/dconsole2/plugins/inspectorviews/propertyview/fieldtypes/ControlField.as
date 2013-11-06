package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes 
{
	import com.furusystems.dconsole2.IConsole;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ControlField extends Sprite
	{
		public var tf:TextField;
		public var targetProperty:String;
		public var hasFocus:Boolean = false;
		private var _readOnly:Boolean;
		private var _clickOverlay:Sprite;
		private var _type:String;
		private var _doubleClickTarget:Object;
		private var _prevWidth:Number = 0;
		private var access:String;
		private var _console:IConsole;
		public static var FOCUSED_FIELD:ControlField = null;
		
		public function ControlField(console:IConsole, property:String,type:String = "string",access:String = "readwrite") 
		{
			_console = console;
			this.access = access;
			targetProperty = property;
			_type = type;
			tf = new TextField();
			tf.defaultTextFormat = TextFormats.windowDefaultFormat;
			tf.embedFonts = true;
			tf.textColor = Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_FG;
			tf.backgroundColor = Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_BG;
			tf.height = GUIUnits.SQUARE_UNIT;
			tf.selectable = true;
			tf.background = true;
			tf.type = TextFieldType.INPUT;
			tf.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true);
			tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
			addChild(tf);
			var enableMouseWheelControl:Boolean = false;
			var writeable:Boolean = true;
			switch(type.toLowerCase()) {
				case "boolean":
					enableMouseWheelControl = true;
					break;
				case "uint":
					tf.restrict = "0123456789xABCDEF";
					enableMouseWheelControl = true;
					break;
				case "int":
					tf.restrict = "0123456789xABCDEF-";
					enableMouseWheelControl = true;
					break;
				case "number":
					tf.restrict = "0123456789xABCDEF.-";
					enableMouseWheelControl = true;
					break;
				case "array":
					readOnly = true;
					value = "Array";
					writeable = false;
					break;
				case "string":
					writeable = true;
					break;
				case "object":
				default:
					if (type.toLowerCase().indexOf("::") > -1) {
						enableDoubleClickToSelect();
					}
					writeable = false;
					break;
			}
			readOnly = ((access != "readwrite" && access != "writeonly") || !writeable);
			if (enableMouseWheelControl && !readOnly) { 
				tf.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			}
		}
		
		public function enableDoubleClickToSelect(target:Object = null):void
		{
			if (_clickOverlay) return;
			_doubleClickTarget = target;
			tf.type = TextFieldType.DYNAMIC;
			tf.selectable = false;
			_clickOverlay = new Sprite();
			addChild(_clickOverlay);
			_clickOverlay.buttonMode = true;
			_clickOverlay.doubleClickEnabled = true;
			_clickOverlay.addEventListener(MouseEvent.DOUBLE_CLICK, onObjectTargetDoubleClick, false, 0, true);
		}
		
		private function onObjectTargetDoubleClick(e:MouseEvent):void 
		{
			if (_doubleClickTarget) {
				if (_doubleClickTarget is DisplayObject) {
					_console.executeStatement("select " + DisplayObject(_doubleClickTarget).name);
				}else {
					_console.executeStatement("select " + targetProperty);
				}
			}else {
				_console.executeStatement("select " + targetProperty);
			}
		}
		
		private function onFocusOut(e:FocusEvent):void 
		{
			hasFocus = false;
			removeEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			tf.backgroundColor = 0xFFFFFF - tf.backgroundColor;
			tf.textColor = 0xFFFFFF - tf.textColor;
			FOCUSED_FIELD = null;
		}
		
		private function onFocusIn(e:FocusEvent):void 
		{
			hasFocus = true;
			addEventListener(KeyboardEvent.KEY_DOWN, onEnter, false, 0, true);
			tf.backgroundColor = 0xFFFFFF - tf.backgroundColor;
			tf.textColor = 0xFFFFFF - tf.textColor;
			if (tf.selectable) {
				//info("Select all");
				tf.setSelection( -1, tf.text.length);
			}
			FOCUSED_FIELD = this;
		}
		
		private function onEnter(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER) {
				onTextfieldChange();
			}
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if (!hasFocus) return;
			var d:Number = Math.max( -1, Math.min(1, e.delta));
			if(_type!="Boolean"){
				var num:Number = Number(tf.text);
				if (e.shiftKey) {
					d *= 0.1;
				}
				if (e.ctrlKey) {
					d *= 0.1;
				}
				num += d;
				tf.text = num.toString();
			}else {
				tf.text = d > 0?"true":"false";
			}
			onTextfieldChange();
		}
		public function get value():*{
			return tf.text;
		}
		public function set value(n:*):void {
			if (n != null) tf.text = n.toString();
			else if (n == null) {
				tf.text = "null";
			}
		}
		override public function get width():Number { return super.width; }
		
		override public function set width(value:Number):void 
		{
			tf.width = value;
			if (_clickOverlay) {
				_clickOverlay.graphics.clear();
				_clickOverlay.graphics.beginFill(_readOnly?Colors.LOCKED:Colors.ENABLED, .2);
				_clickOverlay.graphics.drawRect(0, 0, value, GUIUnits.SQUARE_UNIT);
				_clickOverlay.graphics.endFill();
			}
			_prevWidth = value;
		}
		
		public function get readOnly():Boolean { return _readOnly; }
		
		public function set readOnly(value:Boolean):void 
		{
			tf.type = (_readOnly = value)?TextFieldType.DYNAMIC:TextFieldType.INPUT;
		}
		
		public function get type():String { return _type; }
		
		private function onTextfieldChange(e:Event = null):void 
		{
			try {
				if (type == "string") {
					_console.executeStatement("set " + targetProperty + " '" + value+"'", true);
				}else{
					_console.executeStatement("set " + targetProperty + " " + value, true);
				}
			}catch (e:Error) {
				Error(e.message);
			}
		}
		public function updateAppearance():void {
			width = _prevWidth;
			tf.textColor = Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_FG;
			tf.backgroundColor = Colors.INSPECTOR_PROPERTY_CONTROL_FIELD_BG;
		}
		
	}

}
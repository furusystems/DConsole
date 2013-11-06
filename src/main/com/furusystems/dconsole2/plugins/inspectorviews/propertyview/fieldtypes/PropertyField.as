package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes
{
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import com.furusystems.dconsole2.core.gui.TextFieldFactory;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.TabContent;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class PropertyField extends TabContent
	{
		public var controlField:ControlField;
		public var nameField:TextField;
		private var _readOnly:Boolean = false;
		private var _prevWidth:Number = 0;
		private var splitControl:Sprite = new Sprite();
		private var _mouseOrigX:Number;
		private var _splitRatio:Number = 0.5;
		private var _access:String;
		private var _objRef:Dictionary = new Dictionary(true);
		private var _console:IConsole;
		public function PropertyField(console:IConsole, object:Object,property:String,type:String,access:String = "readwrite") 
		{
			super(property);
			_console = console;
			_access = access;
			_objRef[0] = object;
			nameField = TextFieldFactory.getLabel(property);
			nameField.textColor = Colors.INSPECTOR_PROPERTY_FIELD_NAME_FG;
			nameField.background = true;
			nameField.backgroundColor = Colors.INSPECTOR_PROPERTY_FIELD_NAME_BG;
			addChild(nameField);
			controlField = new ControlField(console, property, type, access);
			nameField.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			nameField.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			controlField.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			controlField.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			addChild(controlField);
			
			splitControl.buttonMode = true;
			splitControl.addEventListener(MouseEvent.MOUSE_DOWN, onSplitBeginDrag, false, 0, true);
			
			splitControl.x = width * _splitRatio;
			splitControl.graphics.clear();
			splitControl.graphics.beginFill(0, 0.1);
			splitControl.graphics.drawRect(0, 0, -5, GUIUnits.SQUARE_UNIT);
			addChild(splitControl);
			
			if(object!=null){
				if (_access != "writeonly") {
					controlField.value = object[property];
				}
			}
			
			
			_prevWidth = width;
		}
		public function splitToName():void {
			splitControl.x = nameField.textWidth;
			_splitRatio = Math.max(.1, Math.min(.9, (splitControl.x / super.width)));
			updateFieldWidths();
		}
		
		private function onSplitBeginDrag(e:MouseEvent):void 
		{
			_mouseOrigX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSplitDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, onSplitRelease);
		}
		
		private function onSplitRelease(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSplitDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onSplitRelease);
		}
		
		private function onSplitDrag(e:MouseEvent):void 
		{
			splitRatio = (splitControl.x + mouseX - _mouseOrigX) / _prevWidth;
			_mouseOrigX = mouseX;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function updateFromSource():void 
		{
			if (!controlField.hasFocus) {
				if (_access != "writeonly") {
					var t:* = _objRef[0][controlField.targetProperty];
					if (t) controlField.value = t;
				}
			}
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			_console.messaging.send(Notifications.TOOLTIP_HIDE_REQUEST, null, this);
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			var t:String = "";
			switch(e.currentTarget) {
				case controlField:
				t = controlField.value;
				break;
				case nameField:
				t = nameField.text;
				break;
			}
			_console.messaging.send(Notifications.TOOLTIP_SHOW_REQUEST, t, this);
		}
		override public function set width(value:Number):void 
		{
			if (value == _prevWidth) return;
			graphics.clear();
			graphics.beginFill(Colors.INSPECTOR_PROPERTY_FIELD_BG);
			graphics.drawRect(0, 0, value, GUIUnits.SQUARE_UNIT);
			graphics.endFill();	
			_prevWidth = value;
			updateFieldWidths();
			scrollRect = new Rectangle(0, 0, value, GUIUnits.SQUARE_UNIT);
		}
		override public function get width():Number {
			return _prevWidth;
		}
		
		private function updateFieldWidths():void
		{
			nameField.width = controlField.x = Math.floor(_prevWidth * _splitRatio)
			controlField.width = Math.floor(_prevWidth * (1-_splitRatio));
			splitControl.x = _prevWidth * _splitRatio;
		}
		
		public function get readOnly():Boolean { return _readOnly; }
		
		public function set readOnly(value:Boolean):void 
		{
			controlField.readOnly = _readOnly = value;
		}
		
		public function get splitRatio():Number { return _splitRatio; }
		
		public function set splitRatio(value:Number):void 
		{
			_splitRatio = Math.max(.1, Math.min(.9, value));
			updateFieldWidths();
		}
		override public function updateAppearance():void 
		{
			super.updateAppearance();
			width = _prevWidth;
			nameField.textColor = Colors.INSPECTOR_PROPERTY_FIELD_NAME_FG;
			nameField.backgroundColor = Colors.INSPECTOR_PROPERTY_FIELD_NAME_BG;
			controlField.updateAppearance();
		}
		
	}

}
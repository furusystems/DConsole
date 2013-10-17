package com.furusystems.dconsole2.plugins.controller 
{
	import com.furusystems.dconsole2.core.gui.Window;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class Controller extends Window
	{
		public var targetObj:*; 
		private var paramsField:TextField = new TextField();
		private var controlFields:Vector.<ControlField> = new Vector.<ControlField>();
		private var clickOffset:Point;
		private var dragArea:Sprite;
		private var closeButton:Sprite;
		private var manager:ControllerUtil;
		private var bg:Shape = new Shape();
		private var contents:Sprite = new Sprite();
		public function Controller(o:*, params:Array,manager:ControllerUtil) 
		{
			//cacheAsBitmap = true;
			
			var dragBarHeight:int = GUIUnits.SQUARE_UNIT;
			this.manager = manager;
			
			targetObj = o;
			paramsField.defaultTextFormat = TextFormats.windowDefaultFormat;
			contents.addChild(paramsField);
			paramsField.multiline = true;
			paramsField.selectable = false;
			paramsField.mouseEnabled = false;
			paramsField.embedFonts = true;
			paramsField.textColor = Colors.HEADER_FG;
			paramsField.autoSize = TextFieldAutoSize.LEFT;
			paramsField.text = o.toString();
			for (var i:int = 0; i < params.length; i++) 
			{
				var cf:ControlField = new ControlField(params[i],typeof targetObj[params[i]]);
				cf.addEventListener(ControllerEvent.VALUE_CHANGE, onCfChange,false,0,true);
				contents.addChild(cf);
				controlFields.push(cf);
				cf.y = paramsField.textHeight;
				cf.x = 110;
				cf.value = o[params[i]];
				paramsField.appendText("\n" + params[i]);
			}
			super("" + o.name, new Rectangle(0, 0, contents.width, contents.height), contents);
		}
		
		
		override protected function onWindowDrag(e:MouseEvent):void 
		{
			super.onWindowDrag(e);
			update();
		}	
		override protected function onClose(e:MouseEvent):void 
		{
			super.onClose(e);
			close(e);
		}
		
		private function close(e:MouseEvent):void 
		{
			manager.removeController(this);
		}
		
		private function onCfChange(e:Event):void 
		{
			var t:ControlField = e.currentTarget as ControlField;
			targetObj[t.targetProperty] = t.value;
			refresh();
		}
		
		private function refresh():void
		{
			for (var i:int = 0; i < controlFields.length; i++) 
			{
				if (controlFields[i].hasFocus) continue;
				controlFields[i].value = targetObj[controlFields[i].targetProperty];
				if (controlFields[i].targetProperty == "name") {
					setTitle(""+targetObj[controlFields[i].targetProperty]);
				}
			}
			
		}
		public function update():void {
			refresh();
			if (targetObj is DisplayObject) {
				var rect:Rectangle = DisplayObject(targetObj).transform.pixelBounds;
				manager.graphics.moveTo(x, y);
				manager.graphics.lineTo(rect.x, rect.y);
				manager.graphics.drawCircle(rect.x, rect.y, 3);
			}
		}
		
		public function destroy():void 
		{
			targetObj = null;
			manager = null;
			graphics.clear();
		}
		
	}

}
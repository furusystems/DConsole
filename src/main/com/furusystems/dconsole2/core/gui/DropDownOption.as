package com.furusystems.dconsole2.core.gui {
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public final class DropDownOption extends Sprite {
		public var title:String;
		private var titleField:TextField;
		public var data:*;
		public var index:int = -1;
		public var isDefault:Boolean;
		
		public function DropDownOption(title:String = "Blah", data:* = null, isDefault:Boolean = false) {
			this.data = data;
			this.isDefault = isDefault;
			this.title = title;
			titleField = new TextField();
			addChild(titleField);
			//titleField.autoSize = TextFieldAutoSize.LEFT;
			titleField.height = GUIUnits.SQUARE_UNIT;
			titleField.defaultTextFormat = TextFormats.consoleTitleFormat;
			titleField.embedFonts = titleField.defaultTextFormat.font.charAt(0) != "_";
			titleField.text = title;
			titleField.mouseEnabled = false;
			titleField.y = 1;
			titleField.background = true;
			titleField.textColor = Colors.DROPDOWN_FG_INACTIVE;
			titleField.backgroundColor = Colors.DROPDOWN_BG_INACTIVE;
			selected = false;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		public function setWidth(w:Number):void {
			titleField.width = w;
		}
		
		private function set selected(b:Boolean):void {
			if (b) {
				titleField.textColor = Colors.DROPDOWN_FG_ACTIVE;
				titleField.backgroundColor = Colors.DROPDOWN_BG_ACTIVE;
			} else {
				titleField.textColor = Colors.DROPDOWN_FG_INACTIVE;
				titleField.backgroundColor = Colors.DROPDOWN_BG_INACTIVE;
			}
		}
		
		private function onMouseOver(e:MouseEvent):void {
			selected = true;
		}
		
		private function onMouseOut(e:MouseEvent):void {
			selected = false;
		}
		
		public function set background(b:Boolean):void {
			titleField.background = b;
		}
		
		public function updateAppearance():void {
			selected = false;
		}
	
	}

}
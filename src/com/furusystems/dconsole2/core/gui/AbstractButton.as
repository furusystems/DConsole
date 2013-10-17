package com.furusystems.dconsole2.core.gui {
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class AbstractButton extends Sprite {
		protected var _bg:Shape = new Shape();
		protected var _iconDisplay:Bitmap = new Bitmap();
		protected var _inactiveBmd:BitmapData;
		protected var _activeBmd:BitmapData;
		protected var _active:Boolean = false;
		protected var _toggleSwitch:Boolean = false;
		protected var _height:Number;
		protected var _width:Number;
		
		public function AbstractButton(width:Number = GUIUnits.SQUARE_UNIT, height:Number = GUIUnits.SQUARE_UNIT) {
			_width = width;
			_height = height;
			addChild(_bg);
			addChild(_iconDisplay);
			active = false;
			buttonMode = true;
			mouseChildren = false;
			scrollRect = new Rectangle(0, 0, width, height);
			addEventListener(MouseEvent.MOUSE_DOWN, doClick, false, 0, true);
		}
		
		protected function doClick(e:MouseEvent):void {
			if (_toggleSwitch) {
				active = !active;
			}
		}
		
		public function setIcon(bmd:BitmapData):void {
			_iconDisplay.bitmapData = bmd;
			_iconDisplay.x = Math.floor(_bg.width / 2 - _iconDisplay.width / 2);
			_iconDisplay.y = Math.floor(_bg.height / 2 - _iconDisplay.height / 2);
		}
		
		public function get active():Boolean {
			return _active;
		}
		
		public function set active(value:Boolean):void {
			_active = value;
			_bg.graphics.clear();
			if (_active) {
				_bg.graphics.beginFill(Colors.BUTTON_ACTIVE_BG);
			} else {
				_bg.graphics.beginFill(Colors.BUTTON_INACTIVE_BG);
			}
			_bg.graphics.drawRect(0, 0, _width, _height);
		}
		
		public function updateAppearance():void {
			active = active;
		}
	
	}

}
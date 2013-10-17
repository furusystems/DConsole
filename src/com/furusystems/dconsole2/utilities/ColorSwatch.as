package com.furusystems.dconsole2.utilities {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class ColorSwatch extends Sprite {
		public var color:ColorDef;
		public static const RADIUS:int = 10;
		private var bg:Shape;
		private var c:Shape;
		private var _selected:Boolean;
		
		public function ColorSwatch(colorDef:ColorDef) {
			buttonMode = true;
			bg = new Shape();
			c = new Shape();
			addChild(bg);
			selected = false;
			addChild(c);
			this.color = colorDef;
			setColor(color.color);
		}
		
		public function set selected(b:Boolean):void {
			_selected = b;
			bg.graphics.clear();
			bg.graphics.beginFill(_selected ? 0xFFFFFF : 0);
			bg.graphics.drawCircle(RADIUS, RADIUS, RADIUS);
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function setColor(color:uint):void {
			this.color.color = color;
			c.graphics.clear();
			c.graphics.beginFill(color);
			c.graphics.drawCircle(RADIUS, RADIUS, RADIUS - 2);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setName(name:String):void {
			this.color.name = name;
		}
	
	}

}
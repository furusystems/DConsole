package com.furusystems.dconsole2.utilities {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class ThemeConfigurer extends Sprite {
		private var palette:PaletteView;
		private var _prevSelection:TextField;
		
		public function ThemeConfigurer(palette:PaletteView) {
			this.palette = palette;
		}
		
		public function save():XML {
			var out:XML = new XML(<data/>);
			return out;
		}
		
		public function populate(theme:XML):void {
			addNode(theme, 0, 0);
		}
		
		public function addNode(xml:XML, x:Number, y:Number):Number {
			var tf:TextField = new TextField();
			tf.height = 20;
			tf.width = 100;
			tf.x = x;
			tf.y = y;
			tf.selectable = false;
			addChild(tf);
			var count:int = 1;
			if (xml.name()) {
				if (xml.text() != null) {
				}
				tf.text = xml.name();
				for each (var node:XML in xml.children()) {
					count += addNode(node, x + 50, tf.y + count * 20);
				}
			} else {
				tf.text = xml;
				tf.backgroundColor = palette.getColorByName(tf.text);
				tf.background = true;
				tf.textColor = 0xFFFFFF - tf.backgroundColor;
				tf.addEventListener(MouseEvent.CLICK, selectField);
			}
			return count;
		}
		
		public function updateColor(color:ColorDef):void {
			for (var i:int = numChildren; i--; ) {
				var tf:TextField = getChildAt(i) as TextField;
				if (tf.text.toLowerCase() == color.name.toLowerCase()) {
					tf.backgroundColor = color.color;
				}
			}
		}
		
		private function selectField(e:MouseEvent):void {
			if (_prevSelection) {
				_prevSelection.border = false;
			}
			_prevSelection = e.currentTarget as TextField;
			_prevSelection.border = true;
			palette.selectSwatchByName(_prevSelection.text);
		}
		
		public function get prevSelection():TextField {
			return _prevSelection;
		}
	
	}

}
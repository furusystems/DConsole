package com.furusystems.dconsole2.core.style {
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public dynamic class ColorCollection {
		private var _xml:XML;
		
		public function ColorCollection() {
		
		}
		
		public function populate(xml:XML):void {
			_xml = xml;
		}
		
		public function getColor(name:String):uint {
			name = name.toLowerCase();
			for each (var n:XML in _xml.*) {
				if (n.localName().toLowerCase() == name) {
					return uint(n.text());
				}
			}
			throw new Error("No such color '" + name + "'");
		}
		
		public function get xml():XML {
			return _xml;
		}
		
		public function set xml(value:XML):void {
			populate(value);
		}
	
	}

}
package com.furusystems.dconsole2.core.style.themes {
	import com.furusystems.dconsole2.core.style.StyleManager;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ConsoleTheme {
		private var _xml:XML;
		private var _styleManager:StyleManager;
		private var _themeData:Object;
		
		public function ConsoleTheme(styleManager:StyleManager) {
			_styleManager = styleManager;
		}
		
		public function populate(xml:XML):void {
			_xml = xml;
			_themeData = populateFromNode(_xml);
		}
		
		private function populateFromNode(node:XML):Object {
			var o:Object;
			if (node.text() != undefined) {
				try {
					o = _styleManager.colors.getColor(node.toString());
				} catch (e:Error) {
					//color lookup failed, so assume the theme file has a hex color
					o = Number(node.toString());
				}
			} else if (node.*.length() > 0) {
				o = {};
				for each (var n:XML in node.*) {
					o[n.localName()] = populateFromNode(n);
				}
			}
			return o;
		}
		
		public function get data():Object {
			return _themeData;
		}
		
		public function get xml():XML {
			return _xml;
		}
		
		public function set xml(value:XML):void {
			populate(value);
		}
	
	}

}
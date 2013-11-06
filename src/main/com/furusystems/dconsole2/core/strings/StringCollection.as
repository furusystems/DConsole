package com.furusystems.dconsole2.core.strings {
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class StringCollection {
		protected var _dictionary:Dictionary = new Dictionary(false);
		
		public function populate(xml:XML):void {
			for each (var node:XML in xml.string) {
				_dictionary[String(node.@id)] = String(node);
			}
		}
		
		public function get(id:String):String {
			if (_dictionary[id] != null) {
				return _dictionary[id] as String;
			}
			return "undefined";
		}
	
	}

}
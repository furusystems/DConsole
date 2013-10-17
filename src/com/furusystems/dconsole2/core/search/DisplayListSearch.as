package com.furusystems.dconsole2.core.search {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class DisplayListSearch {
		/**
		 * Looks down the display tree and looks for a parent of a certain type
		 * @param	type
		 * The class type to look for
		 * @param	start
		 * The child object to start the search from
		 * @return
		 */
		public static function getParentObjectByType(type:Class, start:DisplayObject):* {
			var found:Boolean = false;
			var searching:Boolean = true;
			var currentObject:DisplayObjectContainer = start.parent;
			while (currentObject != start.root && currentObject.parent) {
				if (currentObject is type)
					return currentObject;
				currentObject = currentObject.parent;
			}
			throw new Error("No such parent type found");
		}
		
		public static function getChildObjectsByType(type:Class, start:DisplayObjectContainer):Array {
			var result:Array = [];
			
			return result;
		}
	
	}

}
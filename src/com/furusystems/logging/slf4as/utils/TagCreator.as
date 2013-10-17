package com.furusystems.logging.slf4as.utils {
	import flash.utils.describeType;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class TagCreator {
		static public function getTag(owner:Object):String {
			if (owner is Class) {
				return describeType(owner).@name.split("::").pop();
			} else {
				return "" + owner;
			}
		}
	
	}

}
package com.furusystems.dconsole2.core.plugins {
	
	public interface IParsingDConsolePlugin extends IDConsolePlugin {
		/**
		 * Takes a string input and returns an object
		 * @param	data
		 * The string to parse
		 * @return
		 * The resulting object. If no parsing takes place or it fails, return null
		 */
		function parse(data:String):*;
	}

}
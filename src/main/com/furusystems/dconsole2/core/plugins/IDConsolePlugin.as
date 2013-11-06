package com.furusystems.dconsole2.core.plugins {
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public interface IDConsolePlugin {
		/**
		 * Called to initialize the plugin, instantiate it on stage, register event listeners etc
		 * @param	pm
		 */
		function initialize(pm:PluginManager):void;
		/**
		 * Called to shut down the plugin, remove it from stage, unregister event listeners etc
		 * @param	pm
		 */
		function shutdown(pm:PluginManager):void;
		/**
		 * Should return a short text describing this plugin
		 */
		function get descriptionText():String;
		
		/**
		 * Returns a list of plugin types this plugin requires
		 */
		function get dependencies():Vector.<Class>;
	}

}
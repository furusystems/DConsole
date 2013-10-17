package com.furusystems.dconsole2.core.plugins {
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public interface IUpdatingDConsolePlugin extends IDConsolePlugin {
		/**
		 * Called every frame update the plugin is visible
		 * @param	pm
		 */
		function update(pm:PluginManager):void;
	}

}
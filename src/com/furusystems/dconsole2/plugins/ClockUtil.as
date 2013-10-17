package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	public class ClockUtil implements IDConsolePlugin
	{
		
		public function ClockUtil() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String 
		{
			return "Adds a simple command for getting the current time";
		}
		
		public function initialize(pm:PluginManager):void 
		{
		}
		
		public function shutdown(pm:PluginManager):void 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
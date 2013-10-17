package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class LoadingUtil implements IDConsolePlugin
	{
		
		public function LoadingUtil() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String
		{
			return "Adds generic commands for loading external data";
		}
		
		public function initialize(pm:PluginManager):void
		{
			pm.console.createCommand("loadString", loadString);
			pm.console.createCommand("loadBinary", loadBinary);
			pm.console.createCommand("loadDisplayObject", loadDisplayObject);
		}
		
		private function loadDisplayObject():void
		{
			
		}
		
		private function loadBinary():void
		{
			
		}
		
		private function loadString():void
		{
			
		}
		
		public function shutdown(pm:PluginManager):void
		{
			pm.console.removeCommand("loadString");
			pm.console.removeCommand("loadBinary");
			pm.console.removeCommand("loadDisplayObject");
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
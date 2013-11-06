package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.IConsole;
	import flash.text.Font;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class FontUtil implements IDConsolePlugin
	{
		private var _console:IConsole;
		
		private function printFonts(c:IConsole):void {
			var fnts:Array = Font.enumerateFonts();
			if (fnts.length < 1) {
				c.print("Only system fonts available");
			}
			for (var i:int = 0; i < fnts.length; i++) 
			{
				c.print("	" + fnts[i].fontName);
			}
		}
		private function listFonts():void
		{
			printFonts(_console);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void
		{
			_console = pm.console;
			_console.createCommand("listFonts", listFonts, "FontUtil", "Prints a list of all embedded fonts (excluding system fonts)");
		}
		
		public function shutdown(pm:PluginManager):void
		{
			_console = null;
			_console.removeCommand("listFonts");
		}
		
		public function get descriptionText():String
		{
			return "Enables readouts of embedded fonts";
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
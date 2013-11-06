package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.IConsole;
	import flash.utils.getTimer;
	import com.furusystems.dconsole2.core.commands.FunctionCallCommand;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class PerformanceTesterUtil implements IDConsolePlugin
	{
		private const commandString:String = "testMethods";
		private var _console:IConsole;
		public function PerformanceTesterUtil() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String
		{
			return "Adds a performance test command for comparing execution time for a set of methods";
		}
		
		public function initialize(pm:PluginManager):void
		{
			_console = pm.console;
			_console.createCommand(commandString, doFunctionTest, "Performance", "Runs a set of methods [...x] and returns a table of execution times in milliseconds");
		}
		
		private function doFunctionTest(...functions):void
		{
			if (functions.length < 1) {
				throw new Error("A list of function references must be passed");
			}
			var validEntries:Array = [];
			for each (var f:Function in functions) 
			{
				validEntries.push(f);
			}
			var out:String = "Results:\n";
			for (var i:int = 0; i < validEntries.length; i++) 
			{
				out += i + "\t" + test(validEntries[i]) + "\n";
			}
			_console.print(out);
		}
		private function test(f:Function):Number {
			var btime:Number = getTimer();
			f.call();
			return getTimer() - btime;
		}
		
		public function shutdown(pm:PluginManager):void
		{
			pm.console.removeCommand(commandString);
			_console = null;
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.IConsole;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class BatchRunnerUtil implements IDConsolePlugin
	{
		private var _console:IConsole;
		
		public function BatchRunnerUtil() 
		{
			
		}
		public function runBatch(batch:String):Boolean {
            _console.print("Starting batch", ConsoleMessageTypes.SYSTEM);
			_console.lockOutput();
            var split:Array = batch.split("\n").join("\r").split("\r\r").join("\r").split("\r");
            var result:Boolean = true;
            for (var i:int = 0; i < split.length; i++) 
            {
				try{
					var commandResult:* = _console.executeStatement(split[i]);
				}catch (e:Error) {
					_console.print("Batch: error executing '" + split[i] + "'", ConsoleMessageTypes.ERROR);
				}
            }
            if (result) {
                _console.print("Batch completed", ConsoleMessageTypes.SYSTEM);
            }else {
                _console.print("Batch completed with errors", ConsoleMessageTypes.ERROR);
            }
			_console.unlockOutput();
            return result;
        }
		public function runBatchFromUrl(url:String):void {
			var batchLoader:URLLoader = new URLLoader(new URLRequest(url));
			batchLoader.addEventListener(Event.COMPLETE, onBatchLoaded, false, 0, true);
		}
		private function onBatchLoaded(e:Event):void 
		{
			runBatch(e.target.data);
			e.target.removeEventListener(Event.COMPLETE, onBatchLoaded);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void
		{
			_console = pm.console;
			_console.createCommand("runBatch", runBatch, "Batch", "Interpret a string of commands and execute them in order");
			_console.createCommand("runBatchFromURL", runBatchFromUrl, "Batch", "Load a text file of commands and execute them in order");
		}
		
		public function shutdown(pm:PluginManager):void
		{
			_console = null;
			_console.removeCommand("runBatch");
			_console.removeCommand("runBatchFromURL");
		}
		
		public function get descriptionText():String
		{
			return "Enables batch running of console statements from file";
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
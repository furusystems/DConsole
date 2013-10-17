package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.IConsole;
	import flash.utils.Dictionary;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class CommandMapperUtil implements IDConsolePlugin
	{
		private var _console:IConsole;
		private var methodsCreated:Dictionary = new Dictionary();
		private var _pm:PluginManager;
		public function CommandMapperUtil() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String
		{
			return "Offers fast automatic mapping of public methods to commands";
		}
		
		public function initialize(pm:PluginManager):void
		{
			_console = pm.console;
			_pm = pm;
			pm.console.createCommand("quickmap", doMap,"CommandMapperUtil","Maps every method of the current scope to a command if possible");
		}
		
		private function doMap():void
		{
			var target:IntrospectionScope = _pm.scopeManager.currentScope;
			for (var i:int = 0; i < target.methods.length; i++) 
			{
				_console.createCommand(target.methods[i].name, target.targetObject[target.methods[i].name], target.targetObject.toString());
				methodsCreated[target.methods[i].name] = 1;
			}
		}
		
		public function shutdown(pm:PluginManager):void
		{
			pm.console.removeCommand("quickmap");
			for(var m:String in methodsCreated) {
				pm.console.removeCommand(m);
			}
			_console = null;
			_pm = null;
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
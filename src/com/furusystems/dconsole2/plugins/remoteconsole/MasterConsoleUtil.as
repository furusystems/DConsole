package com.furusystems.dconsole2.plugins.remoteconsole 
{
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.plugins.remoteconsole.io.MasterConsoleServer;
	import com.furusystems.dconsole2.plugins.remoteconsole.io.RemoteConsoleMessage;
	import com.furusystems.dconsole2.plugins.remoteconsole.io.RemoteMessageTypes;
	import com.furusystems.dconsole2.plugins.remoteconsole.io.RemoteSocketConnection;
	/**
	 * Designates the registering DConsole as a remote master console for one or more slave consoles
	 * @author Andreas Rønning
	 */
	public class MasterConsoleUtil implements IDConsolePlugin
	{
		private var server:MasterConsoleServer;
		private var _pm:PluginManager;
		private var _targetSlave:int;
		public function MasterConsoleUtil() 
		{
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String 
		{
			return "Sets up a socket server on port 1984 for slave consoles to connect to";
		}
		
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
		public function initialize(pm:PluginManager):void 
		{
			_pm = pm;
			server = new MasterConsoleServer(pm.console);
			server.initialize();
			pm.console.createCommand("setCurrentSlave", setCurrentSlave, "Remote", "Designates a target remote connection");
		}
		
		private function setCurrentSlave(id:int):void 
		{
			_targetSlave = id;
			_pm.console.setOverrideCallback(tellSlave);
		}
		
		private function tellSlave(input:String):void 
		{
			var m:RemoteConsoleMessage = RemoteConsoleMessage.create(RemoteMessageTypes.STATEMENT, input);
			server.getSlaveByID(_targetSlave).send(m);
		}
		
		public function shutdown(pm:PluginManager):void 
		{
			server.close();
			server = null;
		}
		
	}

}
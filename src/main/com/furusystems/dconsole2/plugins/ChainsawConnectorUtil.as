package com.furusystems.dconsole2.plugins
{
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.logging.slf4as.constants.Levels;
	import com.furusystems.messaging.pimp.Message;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.events.Event;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ChainsawConnectorUtil implements IDConsolePlugin
	{
		private var _socket:Socket;
		private var _console:IConsole;
		private var _connected:Boolean;
		private var _threshold:int = Levels.ALL;
		private var _pm:PluginManager;
		
		public function ChainsawConnectorUtil()
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String
		{
			return "Sets up and maintains a socket connection with Apache Chainsaw";
		}
		
		public function initialize(pm:PluginManager):void
		{
			_console = pm.console;
			_pm = pm;
			pm.console.createCommand("chainsawConnect", connect, "Chainsaw", "Connects to a Chainsaw XMLSocketReceiver at host [x] (default localhost) and port [y] (default 4448)");
			pm.console.createCommand("chainsawDisconnect", disconnect, "Chainsaw", "Disconnects from Chainsaw");
			pm.console.createCommand("chainsawPushlog", pushLog, "Chainsaw", "Pushes the entire log to Chainsaw, top to bottom");
			pm.messaging.addCallback(Notifications.NEW_CONSOLE_OUTPUT, onNewMessage);
		}
		
		private function onNewMessage(md:MessageData):void
		{
			var m:ConsoleMessage = md.data as ConsoleMessage;
			pushMessage(m);
		}
		
		//TEMP
		public function buildXMLNode(m:ConsoleMessage):XML{
			var node:XML = <log4j:event xmlns:log4j="http://logging.apache.org/log4j/" logger="" timestamp="" level="" thread="main" />;
			var date:Date = new Date();
			date.setTime(m.timestamp);
			node.@timestamp = date.getTime();
			node.@logger = "DConsole64."+m.tag;
			switch(m.type) {
					case ConsoleMessageTypes.USER:
						node.@level = "user";
						break;
					case ConsoleMessageTypes.SYSTEM:
						node.@level = "system";
						break;
					case ConsoleMessageTypes.ERROR:
						node.@level = "error";
						break;
					case ConsoleMessageTypes.WARNING:
						node.@level = "warning";
						break;
					case ConsoleMessageTypes.FATAL:
						node.@level = "fatal";
						break;
					case ConsoleMessageTypes.HOORAY:
						node.@level = "hooray";
						break;
					case ConsoleMessageTypes.TRACE:
						node.@level = "trace";
						break;
					case ConsoleMessageTypes.DEBUG:
						node.@level = "debug";
						break;
					case ConsoleMessageTypes.INFO:
						node.@level = "info";
						break;
			}
			node.appendChild(<log4j:message xmlns:log4j = "http://logging.apache.org/log4j/">{m.text}</log4j:message>);
			return node;
		}
		//END TEMP
		private function pushLog():void
		{
			for each(var m:ConsoleMessage in _pm.logManager.rootLog.messages) {
				pushMessage(m);
			}
			//var xml:XML =
			//_socket.writeUTFBytes(xml);
			//_socket.flush();
		}
		private function pushMessage(m:ConsoleMessage):void {
			if (!_connected) return;
			_socket.writeUTFBytes(buildXMLNode(m));
			_socket.flush();
		}
		private function disconnect():void
		{
			_socket.close();
			_socket.removeEventListener(Event.CONNECT, onSocketConnected);
			_socket = null;
			_console.print("Disconnected from chainsaw", ConsoleMessageTypes.SYSTEM, "ChainsawConnector");
			_connected = false;
		}
		
		private function connect(host:String = "localhost",port:int = 4448):void
		{
			if (_socket) {
				disconnect();
			}
			_socket = new Socket(host, port);
			_socket.addEventListener(Event.CONNECT, onSocketConnected);
			_console.print("Connecting...", ConsoleMessageTypes.SYSTEM, "ChainsawConnector");
		}
		
		private function onSocketConnected(e:Event):void
		{
			_connected = true;
			pushLog();
			_console.print("Connected!", ConsoleMessageTypes.SYSTEM, "ChainsawConnector");
		}
		
		public function shutdown(pm:PluginManager):void
		{
			disconnect();
			_console.removeCommand("chainsawConnect");
			_console.removeCommand("chainsawDisconnect");
			_console = null;
			_pm = null;
		}
		
				
		public function get dependencies():Vector.<Class>
		{
			return null;
		}
		
	}

}
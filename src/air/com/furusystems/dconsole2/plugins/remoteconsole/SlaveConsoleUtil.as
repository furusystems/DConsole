package com.furusystems.dconsole2.plugins.remoteconsole 
{
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.plugins.remoteconsole.io.RemoteConsoleMessage;
	import com.furusystems.dconsole2.plugins.remoteconsole.io.RemoteMessageTypes;
	import com.furusystems.dconsole2.plugins.remoteconsole.io.RemoteSocketConnection;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	/**
	 * Designates the registering DConsole as a slave console for one remote master console
	 * @author Andreas Rønning
	 */
	public class SlaveConsoleUtil implements IDConsolePlugin
	{
		private static const L:ILogger = Logging.getLogger(SlaveConsoleUtil);
		private var connection:RemoteSocketConnection;
		private var socket:Socket;
		private var configLoader:URLLoader;
		private var host:String;
		private var connectionTimer:Timer;
		private var _pm:PluginManager;
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String 
		{
			return "Allows this console to run as a slave, passings it logging over a socket and receiving statements to execute";
		}
		
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
		public function initialize(pm:PluginManager):void 
		{
			_pm = pm;
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, onSocketConnected);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketConnectError);
			connection = new RemoteSocketConnection(pm.console, socket);
			configLoader = new URLLoader(new URLRequest("remoteconfig.xml"));
			configLoader.addEventListener(Event.COMPLETE, onConfigLoaded);
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, pm.console.onEvent);
			
			connectionTimer = new Timer(10000,1);
			connectionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onConnectionTimerComplete);
			
		}
		
		private function onConsoleOutput(md:MessageData):void 
		{
			if (connection.connected&&connection.id!=-1) {
				var msg:ConsoleMessage = md.data as ConsoleMessage;
				connection.send(RemoteConsoleMessage.create(RemoteMessageTypes.LOG, msg.text, msg.type, msg.tag)); //TODO: better to properly serialize ConsoleMessage
			}
		}
		
		private function onSocketConnectError(e:IOErrorEvent):void 
		{
			L.debug("Couldn't connect to master.. retrying in 10s"); //Silent mode optional? These prompts may not be necessary
			connectionTimer.reset();
			connectionTimer.start();
		}
		
		private function onSocketConnected(e:Event):void 
		{
			L.info("Connected to master");
			_pm.messaging.addCallback(Notifications.NEW_CONSOLE_OUTPUT, onConsoleOutput);
		}
		
		private function onConnectionTimerComplete(e:TimerEvent):void 
		{
			attemptConnection();
		}
		
		private function attemptConnection():void 
		{
			L.debug("Attempting connection with " + host + ":" + RemoteInfo.PORT);
			socket.connect(host, RemoteInfo.PORT);
		}
		
		private function onConfigLoaded(e:Event):void 
		{
			var xml:XML = new XML(configLoader.data);
			host = xml.host;
			L.debug("Config loaded, host address : " + host);
			attemptConnection();
		}
		
		public function shutdown(pm:PluginManager):void 
		{
			connection.close();
			L.info("Connection closed");
		}
		
	}

}
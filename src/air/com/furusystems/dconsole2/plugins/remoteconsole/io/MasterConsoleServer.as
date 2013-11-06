package com.furusystems.dconsole2.plugins.remoteconsole.io 
{
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.dconsole2.plugins.remoteconsole.RemoteInfo;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import flash.errors.IOError;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ServerSocketConnectEvent;
	import flash.events.TimerEvent;
	import flash.net.DatagramSocket;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.Timer;
	/**
	 * Very simple socket server
	 * @author Andreas Rønning
	 */
	public class MasterConsoleServer extends EventDispatcher
	{
		private var server:ServerSocket;
		private var connections:Vector.<RemoteSocketConnection>;
		private static const L:ILogger = Logging.getLogger(MasterConsoleServer);
		private var console:IConsole;
		private var pingTimer:Timer;
		public function MasterConsoleServer(console:IConsole) 
		{
			this.console = console;
			connections = new Vector.<RemoteSocketConnection>();
			server = new ServerSocket();
			server.addEventListener(ServerSocketConnectEvent.CONNECT, onClientConnected);
			server.addEventListener(Event.CLOSE, onServerClose);
			
			pingTimer = new Timer(15000);
			pingTimer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		private function onServerClose(e:Event):void 
		{
			L.warn("Server closed");
		}
		
		private function onClientConnected(e:ServerSocketConnectEvent):void 
		{
			addClient(e.socket);
		}
		
		private function addClient(socket:Socket):void 
		{
			var c:RemoteSocketConnection = new RemoteSocketConnection(console, socket);
			connections.push(c);
			L.info("New client connected - " + c.id);
		}
		private function removeClient(client:RemoteSocketConnection):void {
			try{
				client.close();
				connections.splice(connections.indexOf(client), 1);
			}catch (e:Error){
				L.error(e);
			}
		}
		public function initialize(port:int = RemoteInfo.PORT, attempt:int = 0):void {
			L.info("Attempting bind to port " + port);
			try{
			server.bind(port);
			}catch (e:IOError) {
				if (attempt < 10) return initialize(port + 1, attempt + 1);
				else L.error("Couldn't find any available ports");
			}catch (e:Error) {
				L.error(e);
			}
			server.listen();
			L.info("Bound, listening");
			
			pingTimer.start();
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			var ping:RemoteConsoleMessage = RemoteConsoleMessage.create(RemoteMessageTypes.PING);
			for each(var r:RemoteSocketConnection in connections) {
				r.send(ping);
			}
		}
		public function getSlaveByID(id:int):RemoteSocketConnection {
			for each(var r:RemoteSocketConnection in connections) {
				if (r.id == id) return r;
			}
			return null;
		}
		
		public function close():void 
		{
			pingTimer.stop();
			console = null;
		}
		
	}

}
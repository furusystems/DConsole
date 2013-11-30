package com.furusystems.dconsole2.plugins.remoteconsole {
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.messaging.pimp.MessageData;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class TelnetUtil implements IDConsolePlugin {
		
		private var _console:IConsole;
		private var socket:ServerSocket;
		private var clients:Vector.<TelnetClient>;
		private static const L:ILogger = Logging.getLogger(TelnetUtil);
		private var _pm:PluginManager;
		public function TelnetUtil() {
		
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String {
			return "Connect to the console via telnet";
		}
		
		public function get dependencies():Vector.<Class> {
			return null;
		}
		
		public function initialize(pm:PluginManager):void {
			_console = pm.console;
			_pm = pm;
			_pm.messaging.addCallback(Notifications.NEW_CONSOLE_OUTPUT, onConsoleOutput);
			socket = new ServerSocket();
			clients = new Vector.<TelnetClient>();
			socket.addEventListener(ServerSocketConnectEvent.CONNECT, onSocketConnection);
			socket.bind(1984);
			socket.listen();
			L.debug("Bound socket to 1984");
		}
		
		private function onConsoleOutput(md:MessageData):void 
		{
			for (var i:int = 0; i < clients.length; i++) 
			{
				clients[i].writeLine(String(md.data));
			}
		}
		
		private function onSocketConnection(e:ServerSocketConnectEvent):void 
		{
			L.debug("Socket connection from " + e.socket.localAddress);
			var client:TelnetClient = new TelnetClient(_console);
			client.socket = e.socket;
			client.buffer = "";
			e.socket.addEventListener(Event.CLOSE, onClientDisconnected);
			e.socket.addEventListener(ProgressEvent.SOCKET_DATA, client.onSocketData);
			clients.push(client);
			L.debug("Connected clients: " + clients.length);
		}
		
		private function onClientDisconnected(e:Event):void 
		{
			L.debug("Client disconnected");
			var s:Socket = e.currentTarget as Socket;
			clients = clients.filter(function(client:TelnetClient, index:int, array:Vector.<TelnetClient>):Boolean { return client.socket != s });
			L.debug("Connected clients: " + clients.length);
		}
		
		public function shutdown(pm:PluginManager):void {
			_console = null;
			_pm.messaging.removeCallback(Notifications.NEW_CONSOLE_OUTPUT, onConsoleOutput);
		}
	
	}

}
import com.furusystems.dconsole2.IConsole;
import com.furusystems.logging.slf4as.ILogger;
import com.furusystems.logging.slf4as.Logging;
import flash.events.ProgressEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
internal class TelnetClient {
	private static const L:ILogger = Logging.getLogger(TelnetClient);
	static private const LF:int = 10;
	static private const CR:int = 13;
	public var console:IConsole;
	public var socket:Socket;
	public var buffer:String = "";
	public function TelnetClient(console:IConsole) 
	{
		super();
		this.console = console;
		
		
	}
	public function writeLine(line:String):void {
		var split:Array = line.split("");
		var out:ByteArray = new ByteArray();
		while (split.length > 0) {
			out.writeByte(String(split.shift()).charCodeAt(0));
		}
		out.writeByte(LF);
		out.writeByte(CR);
		out.position = 0;
		socket.writeBytes(out);
		socket.flush();
	}
	
	public function onSocketData(e:ProgressEvent):void 
	{
		var temp:ByteArray = new ByteArray();
		socket.readBytes(temp);
		temp.position = 0;
		var byte:int = temp.readByte();
		if (byte == CR) {
			console.executeStatement(buffer);
			buffer = "";
		}else {
			buffer += String.fromCharCode(byte);
		}
	}
}
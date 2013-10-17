package com.furusystems.dconsole2.plugins.remoteconsole.io 
{
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class RemoteSocketConnection 
	{
		public var connection:Socket;
		private static var UID:int = 0;
		private var _id:int = -1; //as long as the ID is -1, this connection can't do much
		private var console:IConsole;
		private static const L:ILogger = Logging.getLogger(RemoteSocketConnection);
		public function RemoteSocketConnection(console:IConsole, connection:Socket) 
		{
			this.console = console;
			this.connection = connection;
			connection.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			if (connection.connected) { //if the socket is already connected we are assuming it's an incoming connection
				setID(UID++); //and decide its ID
			}
		}
		
		private function onSocketData(e:ProgressEvent):void 
		{
			var m:RemoteConsoleMessage = RemoteConsoleMessage.readSocket(connection);
			switch(m.type) {
				case RemoteMessageTypes.PING:
					//respond
					m = RemoteConsoleMessage.create(RemoteMessageTypes.PONG);
					m.writeToSocket(connection);
					break;
				case RemoteMessageTypes.HANDSHAKE:
					_id = m.data;
					confirmHandshake(_id);
					break;
				case RemoteMessageTypes.LOG:
					console.print(m.text, m.msgtype, m.senderID + ":" + m.data);
					break;
				case RemoteMessageTypes.STATEMENT:
					try{
						console.executeStatement(m.text);
					}catch (e:Error) {
						console.print("" + e, ConsoleMessageTypes.ERROR, _id + "");
					}
					break;
			}
		}
		
		private function confirmHandshake(id:int):void 
		{
			//TODO: PIngback from server to guarantee connection
			L.info("My assigned ID - " + id);
			send(RemoteConsoleMessage.create(RemoteMessageTypes.LOG, "Hello world", ConsoleMessageTypes.HOORAY, "Wubbawubba"));
		}
		
		//called by the server to designate an identifier
		public function setID(id:int):void 
		{
			_id = id;
			connection.writeInt(RemoteMessageTypes.HANDSHAKE);
			connection.writeInt(-1);
			connection.writeInt(_id);
			connection.flush();
		}
		public function close():void {
			connection.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			connection.close();
		}
		
		public function send(msg:RemoteConsoleMessage):void 
		{
			if (id != -1) {
				msg.senderID = id;
				msg.writeToSocket(connection);
			}else {
				L.warn("Attempted to send data prior to handshake completion");
			}
		}
		
		/* DELEGATE flash.net.Socket */
		
		public function get connected():Boolean 
		{
			return connection.connected;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}
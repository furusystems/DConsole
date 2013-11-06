package com.furusystems.dconsole2.plugins.remoteconsole.io 
{
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import flash.net.Socket;
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class RemoteConsoleMessage 
	{
		public var senderID:int = -1;
		public var text:String;
		public var msgtype:String;
		public var data:*;
		public var type:int;
		private static const LOG_SPLIT_TOKEN:String = "@£$"; //quick and dirty :P
		private static const L:ILogger = Logging.getLogger(RemoteConsoleMessage);
		public static function readSocket(connection:Socket):RemoteConsoleMessage {
			var m:RemoteConsoleMessage = new RemoteConsoleMessage();
			m.type = connection.readInt();
			m.senderID = connection.readInt();
			switch(m.type) {
				case RemoteMessageTypes.PING:
				case RemoteMessageTypes.PONG:
					break;
				case RemoteMessageTypes.HANDSHAKE:
					m.data = connection.readInt();
					break;
				case RemoteMessageTypes.LOG:
					var s:String = connection.readUTFBytes(connection.bytesAvailable);
					var split:Array = s.split(LOG_SPLIT_TOKEN);
					m.text = split.pop();
					m.msgtype = split.pop();
					m.data = split.pop();
					break;
				case RemoteMessageTypes.STATEMENT:
					m.text = connection.readUTFBytes(connection.bytesAvailable);
					break;
			}
			return m;
		}
		public static function create(type:int, text:String = "", msgtype:String = "", tag:String = ""):RemoteConsoleMessage {
			var m:RemoteConsoleMessage = new RemoteConsoleMessage();
			m.type = type;
			m.text = text;
			m.data = tag;
			m.msgtype = msgtype;
			return m;
		}
		public function writeToSocket(socket:Socket):void {
			socket.writeInt(type);
			socket.writeInt(senderID);
			switch(type) {
				case RemoteMessageTypes.PING:
				case RemoteMessageTypes.PONG:
					break;
				case RemoteMessageTypes.HANDSHAKE:
					socket.writeInt(data);
					break;
				case RemoteMessageTypes.LOG:
					var t:String = data + LOG_SPLIT_TOKEN + msgtype + LOG_SPLIT_TOKEN + text;
					socket.writeUTFBytes(t);
					break;
				case RemoteMessageTypes.STATEMENT:
					socket.writeUTFBytes(text);
					break;
			}
			socket.flush();
		}
		
	}

}
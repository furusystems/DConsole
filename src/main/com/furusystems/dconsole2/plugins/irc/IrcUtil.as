package com.furusystems.dconsole2.plugins.irc
{
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class IrcUtil implements IDConsolePlugin 
	{
		private var nc:Socket;
		private var USER:String = "USER DoomsdayIRC 8 * :DoomsdayIdent";
		private var NICK:String = "ddIRC";
		private var HOST:String = "irc.homelien.no";
		private var PORT:int = 6667;
		private var CHANNEL:String;
		
		private var pingTimer:Timer = new Timer(20000);
		private var _pm:PluginManager;
		
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String 
		{
			return "Adds a simple one-channel IRC client";
		}
		
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
		public function initialize(pm:PluginManager):void 
		{
			_pm = pm;
			pingTimer.addEventListener(TimerEvent.TIMER, ping);
			
			nc = new Socket();
			nc.addEventListener(Event.CONNECT, onConnect);
			nc.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			nc.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			pm.console.defaultInputCallback = tellChannel;
			pm.console.createCommand("ircsend", send, "IRC", "Sends a message to the current IRC channel.");
			pm.console.createCommand("ircjoin", join,"IRC","Joins an IRC channel.");
			pm.console.createCommand("ircpart", part,"IRC","Parts the designated IRC channel.");
			pm.console.createCommand("ircconnect", connect, "IRC", "Initializes the IRC client and connects to the given server");
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			_pm.console.print("IRC couldn't connect: "+e.text, ConsoleMessageTypes.ERROR, "IRC");
		}
		
		public function shutdown(pm:PluginManager):void 
		{
			nc.close();
			nc.removeEventListener(Event.CONNECT, onConnect);
			nc.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			nc = null;
			
			pm.console.defaultInputCallback = null;
			pm.console.removeCommand("ircsend");
			pm.console.removeCommand("ircjoin");
			pm.console.removeCommand("ircpart");
			pm.console.removeCommand("ircconnect");
			
			_pm = null;
		}
		private function connect(nick:String, host:String = "irc.homelien.no", port:int = 6669):void {
			HOST = host;
			NICK = nick;
			PORT = port;
			_pm.console.print("Connecting to " + host + ":" + port);
			nc.connect(host, PORT);
		}
		private function send(str:String):void {
			nc.writeUTFBytes(str+"\n");
			nc.flush();
		}
		private function tellChannel(str:String):void {
			send("PRIVMSG " + CHANNEL + " :" + str);
			ircOutput(NICK + ": " + str);
		}
		private function join(channel:String):void {
			part();
			send("JOIN " + channel);
			CHANNEL = channel;
		}
		private function part():void {
			send("PART " + CHANNEL);
		}
		
		private function onSocketData(e:ProgressEvent):void 
		{
			// :Lost!lost@isplink.org PRIVMSG #actionscript :
			var out:String = "";
			var split:Array;
			var message:String = nc.readUTFBytes(nc.bytesAvailable);
			ircOutput(message);
			return;
			if (nc.bytesAvailable&&nc.bytesAvailable>20) {
				var message:String = nc.readUTFBytes(nc.bytesAvailable);
				if (message.indexOf("PONG") > -1) return; //we ignore ping returns				
				if (message.indexOf("PRIVMSG") > -1) {
					split = message.split(":");
					out += split[1].split("!").shift();
					out += ": " + split[2];
				}else if (message.indexOf("JOIN") > -1) {
					split = message.split(":");
					out += split[1].split("!").shift() + " has joined "+CHANNEL;
				}else if (message.indexOf("PART") > -1) {
					split = message.split(":");
					out += split[1].split("!").shift() + " has left "+CHANNEL;
				}else {
					out += message;
				}
				ircOutput(out);
			}
		}
		
		private function ircOutput(out:String):void 
		{
			_pm.console.print(out, ConsoleMessageTypes.DEBUG, "IRC");
		}
		
		private function onConnect(e:Event):void 
		{
			send(USER);
			send("NICK " + NICK);
			pingTimer.start();
		}
		private function ping(e:TimerEvent):void {
			send("PING " + HOST);
		}
		
	}
	
}
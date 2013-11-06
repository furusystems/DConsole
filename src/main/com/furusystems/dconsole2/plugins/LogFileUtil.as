package com.furusystems.dconsole2.plugins 
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.net.FileReference;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class LogFileUtil implements IDConsolePlugin
	{
		private var _pmanager:PluginManager;
		private var _fileRef:FileReference = new FileReference();
		public function copyToClipboard(arg:String = "txt"):String {
			var data:*;
			switch(arg.toLowerCase()) {
				case "txt":
				case "text":
					data = buildLogTxt();
				break;
				case "xml":
					data = buildLogXML();
				break;
			}
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, data, false);
			return "Copied log to system clipboard";
		}
		public function buildLogXML():XML {
			var messages:Vector.<ConsoleMessage> = _pmanager.logManager.currentLog.messages;
			var logDoc:XML = <log4j:log xmlns:log4j="http://logging.apache.org/log4j/" />;
			var date:Date;
			for (var i:int = 0; i < messages.length; i++) 
			{
				var node:XML = <log4j:event xmlns:log4j="http://logging.apache.org/log4j/" logger="" timestamp="" level="" thread="main" />;
				date = new Date();
				date.setTime(messages[i].timestamp);
				node.@timestamp = date.getTime();
				node.@logger = messages[i].tag;
				switch(messages[i].type) {
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
				node.appendChild(<log4j:message xmlns:log4j="http://logging.apache.org/log4j/" >{"<![CDATA["+messages[i].text+"]]>"}</log4j:message>);
				logDoc.appendChild(node);
			}
			var dateStr:String;
			dateStr = new Date().toString().split(" ").join("_");
			dateStr = dateStr.split(":").join("-");
			logDoc.@date = dateStr;
			return logDoc;
		}
		
		private function buildLogTxt():String
		{
			var messages:Vector.<ConsoleMessage> = _pmanager.logManager.currentLog.messages;
			var out:String = "";
			var date:Date;
			for (var i:int = 0; i < messages.length; i++) 
			{
				date = new Date();
				date.setTime(messages[i].timestamp);
				if(i==0){
					out += date.toString() + "\r\n";
				}
				out += date.toTimeString().split(" ")[0] + "\t";
				switch(messages[i].type) {
						case ConsoleMessageTypes.USER:
							out += "[USER]\t";
						break;
						case ConsoleMessageTypes.SYSTEM:
							out += "[SYSTEM]\t";
						break;
						case ConsoleMessageTypes.ERROR:
							out += "[ERROR]\t";
						break;
						case ConsoleMessageTypes.WARNING:
							out += "[WARNING]\t";
						break;
						case ConsoleMessageTypes.FATAL:
							out += "[FATAL]\t";
						break;
						case ConsoleMessageTypes.HOORAY:
							out += "[HOORAY]\t";
						break;
						case ConsoleMessageTypes.TRACE:
							out += "[TRACE]\t";
							break;
						case ConsoleMessageTypes.DEBUG:
							out += "[DEBUG]\t";
							break;
						case ConsoleMessageTypes.INFO:
							out += "[INFO]\t";
							break;
				}
				out += messages[i].text + "\r\n";
			}
			return out;
			//var dateStr:String = new Date().toString().split(" ").join("_");
			//dateStr = dateStr.split(":").join("-");
			//_fileRef.save(out, "ConsoleLog_" + dateStr + ".txt");
		}
		
		private function saveLog(arg:String = "txt"):String
		{
			var data:*;
			var extension:String;
			switch(arg.toLowerCase()) {
				case "txt":
				case "text":
					data = buildLogTxt();
					extension = ".txt";
				break;
				case "xml":
					data = buildLogXML();
					extension = ".xml";
				break;
			}
			_fileRef.save(data, "ConsoleLog_" + new Date().toString() + extension);
			return "Saved log";
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void
		{
			_pmanager = pm;
			_pmanager.console.createCommand("saveLog", saveLog, "LogFileUtil", "Save the complete console log for this session to an xml or txt document (txt default)");
			_pmanager.console.createCommand("logToClipboard", copyToClipboard, "LogFileUtil", "Copy a the console log for this session to the clipboard, xml or txt (txt default)");
		}
		
		public function shutdown(pm:PluginManager):void
		{
			_pmanager = null;
			pm.console.removeCommand("saveLog");
		}
		
		public function get descriptionText():String
		{
			return "Enables the saving of console sessions to file";
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
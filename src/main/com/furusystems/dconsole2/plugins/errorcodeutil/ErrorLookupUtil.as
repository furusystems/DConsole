package com.furusystems.dconsole2.plugins.errorcodeutil 
{
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.messaging.pimp.MessageData;
/**
 * ...
 * @author Andreas Rønning
 */
	public class ErrorLookupUtil implements IDConsolePlugin
	{
		[Embed(source='ErrorCodes2.xml',mimeType='application/octet-stream')]
		private static var ERROR_CODE_XML:Class;
		private var _errorCodes:XML;
		private var _lastErrorDescribed:int;
		private var _pm:PluginManager;
		private var _autoDescribe:Boolean = false;
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String 
		{
			return "Offers an error code lookup and additional error info when they occur";
		}
		
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
		public function initialize(pm:PluginManager):void 
		{
			_pm = pm;
			_lastErrorDescribed = -1;
			_errorCodes = new XML(new ERROR_CODE_XML);
			pm.messaging.addCallback(Notifications.NEW_CONSOLE_OUTPUT, onNewConsoleOutput);
			pm.console.createCommand("describeError", describeError, "ErrorLookupUtil", "Pass in an error code [x] and, if it exists, get a description of it. For verbose output, append 'true' as [y]");
			pm.console.createCommand("toggleAutoErrorDescribe", toggleAutoErrorDescription, "ErrorLookupUtil", "Toggles a behavior, defaulting to off, where the console will spit out error descriptions when errors are encountered");
		}
		
		private function toggleAutoErrorDescription():void 
		{
			_autoDescribe = !_autoDescribe;
		}
		
		private function describeError(codeQuery:int, verboseMode:Boolean = false ):void 
		{
			var out:String = null;
			var list:XMLList = _errorCodes.*.(code == codeQuery);
			if (list.length() > 0) {
				out = list[0].message;
				if(verboseMode)	out = "\n"+list[0].description;
			}
			if (out != null) {
				_pm.console.print(out, ConsoleMessageTypes.SYSTEM, "ErrorLookup");
			}
		}
		
		private function onNewConsoleOutput(md:MessageData):void 
		{
			//trace(md.data);
			if (!_autoDescribe) return;
			//if (String(md.data).indexOf("Error #") > -1) {
				//
			//}
		}
		
		public function shutdown(pm:PluginManager):void 
		{
			_errorCodes = null;
			pm.messaging.removeCallback(Notifications.NEW_CONSOLE_OUTPUT, onNewConsoleOutput);
			pm.console.removeCommand("describeError");
			_pm = null;
		}

	}

}

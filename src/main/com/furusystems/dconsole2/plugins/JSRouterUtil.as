package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.Message;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.system.System;
	
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
	public class JSRouterUtil implements IDConsolePlugin
	{
		
		
		private var _routingToJS:Boolean;
		private var _alertingErrors:Boolean;
		private var _console:IConsole;
		private var _logFunction:String;
		
		/**
		 * Toggle: Route all print statements to javascript console.log through externalinterface
		 */
		private function routeToJS(func:String = "console.log"):void {
			_logFunction = func;
			if (ExternalInterface.available) {
				_routingToJS = !_routingToJS;
				if (_routingToJS) {
					_console.print("Routing console to JS", ConsoleMessageTypes.INFO);
				}else {
					_console.print("No longer routing console to JS", ConsoleMessageTypes.INFO);
				}
			}else {
				_console.print("ExternalInterface not available", ConsoleMessageTypes.ERROR);
			}
		}
		/**
		 * Route errors to javascript console.log through externalinterface
		 */
		private function alertErrors():void {
			if (ExternalInterface.available) {
				_alertingErrors = !_alertingErrors;
				if (_alertingErrors ) {
					_console.print("Alerting errors through JS", ConsoleMessageTypes.INFO);
				}else {
					_console.print("No longer alerting errors through JS", ConsoleMessageTypes.INFO);
				}
			}else {
				_console.print("ExternalInterface not available", ConsoleMessageTypes.ERROR);
			}
		}
		
		private function onError(md:MessageData):void 
		{
			var m:ConsoleMessage = md.data as ConsoleMessage;
			if (_alertingErrors) ExternalInterface.call("alert", m.text);
			else if (_routingToJS) onNewMessage(md);
		}
		
		private function onNewMessage(md:MessageData):void 
		{
			var m:ConsoleMessage = md.data as ConsoleMessage ;
			if (_routingToJS) ExternalInterface.call(_logFunction, m.type + ":" + m.text);
		}
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void
		{
			_console = pm.console;
			pm.messaging.addCallback(Notifications.NEW_CONSOLE_OUTPUT, onNewMessage);
			pm.messaging.addCallback(Notifications.ERROR, onError);
			_console.createCommand("routeToJS", routeToJS, "JavaScript", "Toggles routing of all messages to a given js function X (default 'console.log')");
			_console.createCommand("alertErrors", alertErrors, "JavaScript", "Toggles js-alerting of errors caught by the console");
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("execute", execute);
			}
		}
		
		private function execute(command:String):void 
		{
			_console.executeStatement(command, true);
		}
		
		public function shutdown(pm:PluginManager):void
		{
			_console.removeCommand("routeToJS");
			_console.removeCommand("alertErrors");
			pm.messaging.removeCallback(Notifications.NEW_CONSOLE_OUTPUT, onNewMessage);
			pm.messaging.removeCallback(Notifications.ERROR, onError);
			_console = null;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String
		{
			return "Enables console access to javascript log/alert, and javascript access to console executeStatement";
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
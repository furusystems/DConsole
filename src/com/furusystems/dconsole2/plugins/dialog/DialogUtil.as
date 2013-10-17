package com.furusystems.dconsole2.plugins.dialog 
{
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.messaging.pimp.IMessageReceiver;
	import com.furusystems.messaging.pimp.Message;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.events.KeyboardEvent;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.plugins.dialog.DialogDesc;
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	public class DialogUtil implements IDConsolePlugin, IMessageReceiver
	{
		static private const L:ILogger = Logging.getLogger(DialogUtil);
		private var _currentDialog:DialogSequence;
		private var _console:IConsole;
		public function DialogUtil() 
		{
			
		}
		
		private function abortDialog():void 
		{
			_currentDialog = null;
			_console.print("Dialog aborted", ConsoleMessageTypes.SYSTEM);
			_console.clearOverrideCallback();
			_console.messaging.send(DialogNotifications.ABORT_DIALOG, null, this);
			PimpCentral.removeReceiver(this, Notifications.ESCAPE_KEY);
		}
		
		private function startDialog(dialog:DialogDesc):void 
		{
			_currentDialog = new DialogSequence(_console, dialog);
			_currentDialog.next();
			PimpCentral.addReceiver(this, Notifications.ESCAPE_KEY);
		}
		
		
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String 
		{
			return "Offers a scripted request/response system for querying the user for data";
		}
		
		public function initialize(pm:PluginManager):void 
		{
			pm.messaging.addReceiver(this, DialogNotifications.START_DIALOG);
			_console = pm.console;
		}
		
		public function shutdown(pm:PluginManager):void 
		{
			pm.messaging.removeReceiver(this, DialogNotifications.START_DIALOG);
			pm.messaging.removeReceiver(this, Notifications.ESCAPE_KEY);
		}
		
		/* INTERFACE com.furusystems.messaging.pimp.IMessageReceiver */
		
		public function onMessage(md:MessageData):void 
		{
			switch(md.message) {
				case DialogNotifications.START_DIALOG:
					var dialog:DialogDesc = md.data as DialogDesc;
					startDialog(dialog);
				break;
				case Notifications.ESCAPE_KEY:
					abortDialog();
				break;
			}
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
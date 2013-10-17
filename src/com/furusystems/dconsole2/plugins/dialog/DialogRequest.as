package com.furusystems.dconsole2.plugins.dialog 
{
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.PimpCentral;
	
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * Describes an individual dialog request
	 * @author Andreas Ronning
	 */
	public class DialogRequest 
	{
		private var _question:String;
		private var _sequence:DialogSequence;
		private var _console:IConsole;
		
		public function DialogRequest(console:IConsole, question:String,sequence:DialogSequence) 
		{
			_console = console;
			_sequence = sequence;
			_question = question;
		}
		public function execute():void {
			_console.print(_question, ConsoleMessageTypes.SYSTEM);
			_console.messaging.send(Notifications.ASSISTANT_MESSAGE_REQUEST, _question + " (Type your response and hit enter)");
			_console.setOverrideCallback(handleResponse);
		}
		
		private function handleResponse(response:String):void 
		{
			var parsed:* = null;
			var tlc:String = response.toLowerCase();
			
			if (tlc == "yes" || tlc == "true") {
				parsed = true;
			}else if (tlc == "no" || tlc == "false") {
				parsed = false;
			}else {
				parsed = response;
			}
			_sequence.addResult(parsed);
			_console.messaging.send(Notifications.ASSISTANT_CLEAR_REQUEST);
			_console.clearOverrideCallback();
			_sequence.next();
		}
		
	}

}
package com.furusystems.dconsole2.plugins.dialog 
{
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.logging.slf4as.ILogger;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.messaging.pimp.PimpCentral;
	
	/**
	 * Describes a sequence of dialog requests
	 * @author Andreas Ronning
	 */
	public class DialogSequence 
	{
		static private const L:ILogger = Logging.getLogger(DialogSequence);
		private var _requests:Vector.<DialogRequest> = new Vector.<DialogRequest>();
		private var _results:DialogResult = new DialogResult();
		private var _messaging:PimpCentral;
		public function DialogSequence(console:IConsole, desc:DialogDesc) 
		{
			_messaging = console.messaging;
			for each(var question:String in desc.requests) {
				var request:DialogRequest = new DialogRequest(console, question, this);
				addRequest(request);
			}
		}
		public function addRequest(request:DialogRequest):void {
			_requests.push(request);
		}
		public function next():void {
			if(_requests.length>0){
				_requests.shift().execute();
			}else {
				_messaging.send(DialogNotifications.DIALOG_COMPLETE, _results, this);
			}
		}
		
		public function addResult(response:String):void 
		{
			_results.addResult(response);
		}
		
	}

}
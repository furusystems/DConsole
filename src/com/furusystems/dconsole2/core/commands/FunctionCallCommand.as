package com.furusystems.dconsole2.core.commands{
	import flash.utils.Dictionary;
	/**
	 * Concrete command for calling a function
	 * @author Andreas Roenning
	 */
	public class FunctionCallCommand extends ConsoleCommand
	{
		private var _callbackDict:Dictionary;
		/**
		 * Creates a callback command, which calls a function when triggered
		 * @param	trigger
		 * The trigger phrase
		 * @param	callback
		 * The function to call
		 */
		public function FunctionCallCommand(trigger:String, callback:Function, grouping:String = "Application", helpText:String = "")
		{
			_callbackDict = new Dictionary(true);
			_callbackDict["callback"] = callback; //Safing it. Do instance method referenced in a variable get GC'd? In this case they should, right?
			super(trigger);
			this.grouping = grouping;
			this.helpText = helpText;
		}
		public function get callback():Function {
			return _callbackDict["callback"] as Function;
		}
		
	}
	
}
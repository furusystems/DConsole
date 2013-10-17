package com.furusystems.dconsole2.core.commands 
{
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class UnparsedCommand extends FunctionCallCommand
	{
		
		public function UnparsedCommand(trigger:String, callback:Function, grouping:String = "Application", helpText:String = "") 
		{
			super(trigger, callback, grouping, helpText);
		}
		
	}

}
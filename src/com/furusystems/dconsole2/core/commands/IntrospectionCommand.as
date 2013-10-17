package com.furusystems.dconsole2.core.commands 
{
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class IntrospectionCommand extends FunctionCallCommand
	{
		
		public function IntrospectionCommand(trigger:String, callback:Function, grouping:String = "Application", helpText:String = "") 
		{
			super(trigger, callback, grouping, helpText);
		}
		
	}

}
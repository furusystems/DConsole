package com.furusystems.dconsole2.plugins.dialog 
{
	/**
	 * Describes a full set of questions/responses for a dialog
	 * @author Andreas Ronning
	 */
	public class DialogDesc 
	{
		public var requests:Array = [];
		public function DialogDesc(...requests:Array) 
		{
			this.requests = requests;
		}
		
	}

}
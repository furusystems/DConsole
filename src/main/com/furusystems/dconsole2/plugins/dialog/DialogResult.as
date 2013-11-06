package com.furusystems.dconsole2.plugins.dialog 
{
	/**
	 * VO containing a vector of string responses 
	 * @author Andreas Ronning
	 */
	public class DialogResult 
	{
		private var _result:Vector.<String> = new Vector.<String>();
		public function addResult(result:String):void {
			_result.push(result);
		}
		public function get results():Vector.<String> 
		{
			return _result;
		}
		
	}

}
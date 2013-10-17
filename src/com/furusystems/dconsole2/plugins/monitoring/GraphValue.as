package com.furusystems.dconsole2.plugins.monitoring 
{
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public final class GraphValue
	{
		
		public var next:GraphValue = null;
		public var value:Number = 0;
		public var creationTime:int = 0;
		public function GraphValue() 
		{
			
		}
	}

}
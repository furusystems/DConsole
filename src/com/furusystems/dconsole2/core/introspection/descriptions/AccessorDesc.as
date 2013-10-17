package com.furusystems.dconsole2.core.introspection.descriptions
{
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class AccessorDesc extends NamedDescription
	{
		//<accessor name="stage" access="readonly" type="flash.display::Stage" declaredBy="flash.display::DisplayObject"/>
		public var access:String;
		public var type:String;
		public var declaredBy:String;
		public function AccessorDesc(xml:XML) 
		{
			name = xml.@name;
			access = xml.@access;
			type = xml.@type;
			declaredBy = xml.@declaredBy;
		}
		public function toString():String {
			return "Acc: " + name + ":" + access + ":" + type + ":" + declaredBy;
		}
		
	}

}
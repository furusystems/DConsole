package com.furusystems.dconsole2.core.introspection.descriptions {
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class MethodDesc extends NamedDescription {
		// <method name="hitTestObject" declaredBy="flash.display::DisplayObject" returnType="Boolean">
		public var declaredBy:String;
		public var returnType:String;
		public var params:Vector.<ParamDesc> = new Vector.<ParamDesc>();
		
		public function MethodDesc(xml:XML) {
			name = xml.@name;
			declaredBy = xml.@declaredBy;
			returnType = xml.@returnType;
			for each (var n:XML in xml..parameter) {
				params.push(new ParamDesc(n));
			}
		}
	
	}

}
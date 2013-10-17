package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes
{
	import com.furusystems.dconsole2.DConsole;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ObjectField extends PropertyField
	{
		
		public function ObjectField(console:DConsole, object:Object,property:String,type:String, access:String = "readwrite") 
		{
			super(console, object, property, type, access);
		}
		override public function updateFromSource():void 
		{
			
		}
		
	}

}
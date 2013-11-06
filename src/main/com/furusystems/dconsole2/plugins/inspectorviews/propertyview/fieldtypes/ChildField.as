package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes
{
	import com.furusystems.dconsole2.core.introspection.descriptions.ChildScopeDesc;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ChildField extends PropertyField
	{
		public function ChildField(console:IConsole, child:ChildScopeDesc) 
		{
			super(console, null, child.name, "string", "readonly");
			controlField.value = child.type;
			//super(null, child.name, child.type, child.object);
			//readOnly = true;
			controlField.enableDoubleClickToSelect(child.object);
		}
		override public function updateFromSource():void 
		{
			
		}
		
	}

}
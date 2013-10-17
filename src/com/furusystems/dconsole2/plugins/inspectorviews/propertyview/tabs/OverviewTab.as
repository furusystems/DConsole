package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.tabs
{
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes.PropertyField;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class OverviewTab extends PropertyTab
	{
		
		public function OverviewTab(console:IConsole, scope:IntrospectionScope) 
		{
			var className:String = getQualifiedClassName(scope.targetObject);
			super(className.split("::").pop(), true);
			var i:int;
			if (scope.targetObject is DisplayObject) {
				var displayObject:DisplayObject = scope.targetObject as DisplayObject;
				if (displayObject != displayObject.root) addField(new PropertyField(console, scope.targetObject, "name", "string", "readwrite"));
				for (i = 0; i < scope.accessors.length; i++) 
				{
					if (scope.accessors[i].name.toLowerCase() == "parent") {
						addField(new PropertyField(console, scope.targetObject, scope.accessors[i].name, scope.accessors[i].type, scope.targetObject[scope.accessors[i].name]));
						break;
					}
				}
			}
		}
		
	}

}
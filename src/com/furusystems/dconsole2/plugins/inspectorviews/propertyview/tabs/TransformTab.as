package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.tabs 
{
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.DisplayObject;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes.PropertyField;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class TransformTab extends PropertyTab
	{
		
		public function TransformTab(console:IConsole, target:IntrospectionScope) 
		{
			super("Transform", false);
			populate(console,target);
		}
		public function populate(console:IConsole, scope:IntrospectionScope):void {
			if (!(scope.targetObject is DisplayObject)) throw new Error("Cannot populate transform tab with non displayobject scope");
			addField(new PropertyField(console, scope.targetObject, "x", "number"));
			addField(new PropertyField(console, scope.targetObject, "y", "number"));
			addField(new PropertyField(console, scope.targetObject, "z", "number"));
			addField(new PropertyField(console, scope.targetObject, "rotationX", "number"));
			addField(new PropertyField(console, scope.targetObject, "rotationY", "number"));
			addField(new PropertyField(console, scope.targetObject, "rotationZ", "number"));
			addField(new PropertyField(console, scope.targetObject, "width", "number"));
			addField(new PropertyField(console, scope.targetObject, "height", "number"));
			addField(new PropertyField(console, scope.targetObject, "scaleX", "number"));
			addField(new PropertyField(console, scope.targetObject, "scaleY", "number"));
			addField(new PropertyField(console, scope.targetObject, "scaleZ", "number"));
		}
		
	}

}
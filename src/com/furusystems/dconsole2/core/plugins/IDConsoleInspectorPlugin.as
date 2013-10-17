package com.furusystems.dconsole2.core.plugins {
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	import com.furusystems.dconsole2.core.inspector.Inspector;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public interface IDConsoleInspectorPlugin extends IUpdatingDConsolePlugin {
		function get view():AbstractInspectorView;
		function associateWithInspector(inspector:Inspector):void;
		function get title():String;
	}

}
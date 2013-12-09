package com.furusystems.dconsole2.plugins.inspectorviews.notepad 
{
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.inspector.Inspector;
	import flash.display.BitmapData;
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	import com.furusystems.dconsole2.core.plugins.IDConsoleInspectorPlugin;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class NotepadUtil extends AbstractInspectorView
	{
		
		public function NotepadUtil() 
		{
			super("Notepad");
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsoleInspectorPlugin */
		
		override public function get descriptionText():String { 
			return "Adds a simple persistent text input window to the inspector";
		}
		override public function get title():String 
		{
			return "Notepad";
		}
				
		override public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
		
	}

}
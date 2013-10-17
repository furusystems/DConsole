package com.furusystems.dconsole2.core.gui.maindisplay.sections 
{
	import com.furusystems.dconsole2.core.inspector.Inspector;
	import com.furusystems.dconsole2.IConsole;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class InspectorSection extends ConsoleViewSection
	{
		
		public var inspector:Inspector;
		public function InspectorSection(console:IConsole) 
		{
			inspector = new Inspector(console, new Rectangle(0, 0, 50, 50));
			addChild(inspector);
		}
		override public function onParentUpdate(allotedRect:Rectangle):void 
		{
			inspector.onParentUpdate(allotedRect);
		}
		
	}

}
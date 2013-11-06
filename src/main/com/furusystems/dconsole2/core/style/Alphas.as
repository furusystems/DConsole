package com.furusystems.dconsole2.core.style {
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class Alphas {
		public static var CONSOLE_CORE_ALPHA:Number = .9;
		public static var INSPECTOR_ALPHA:Number = .9;
		public static var TREEVIEW_BG_ALPHA:Number = .9;
		
		public static function update(sm:StyleManager):void {
			CONSOLE_CORE_ALPHA = Number(String(sm.theme.data.core.alpha));
			INSPECTOR_ALPHA = Number(String(sm.theme.data.inspector.alpha));
			TREEVIEW_BG_ALPHA = Number(String(sm.theme.data.inspector.treeview.alpha));
		}
	}

}
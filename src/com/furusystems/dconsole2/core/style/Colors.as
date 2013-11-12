package com.furusystems.dconsole2.core.style {
	
	/**
	 * Collection of color references used across the GUI
	 * @author Andreas Roenning
	 */
	public class Colors {
		
		public static var CORE:uint = BaseColors.BLACK;
		
		public static var ENABLED:uint = BaseColors.GREEN;
		public static var DISABLED:uint = BaseColors.GRAY;
		public static var LOCKED:uint = BaseColors.RED;
		
		public static var TOOLTIP_BG:uint = BaseColors.BLACK;
		public static var TOOLTIP_FG:uint = BaseColors.WHITE;
		
		public static var DROPDOWN_BORDER:uint = BaseColors.BLACK;
		public static var DROPDOWN_BG_ACTIVE:uint = BaseColors.BLACK;
		public static var DROPDOWN_FG_ACTIVE:uint = BaseColors.WHITE;
		public static var DROPDOWN_BG_INACTIVE:uint = BaseColors.BLACK;
		public static var DROPDOWN_FG_INACTIVE:uint = BaseColors.WHITE;
		
		public static var SCALEHANDLE_BG:uint = BaseColors.BLACK;
		public static var SCALEHANDLE_FG:uint = BaseColors.WHITE;
		
		public static var SCROLLBAR_FG:uint = BaseColors.BLACK;
		public static var SCROLLBAR_BG:uint = BaseColors.WHITE;
		
		public static var TREEVIEW_BG:uint = BaseColors.BLACK;
		public static var TREEVIEW_FG:uint = BaseColors.WHITE;
		
		public static var MAINSPLIT_DRAG_BAR_BG:uint = BaseColors.BLACK;
		
		public static var ASSISTANT_BG:uint = BaseColors.BLACK;
		public static var ASSISTANT_FG:uint = BaseColors.WHITE;
		
		public static var HEADER_BG:uint = BaseColors.BLACK;
		public static var HEADER_FG:uint = BaseColors.WHITE;
		
		public static var INPUT_BG:uint = BaseColors.BLACK;
		public static var INPUT_BORDER:uint = BaseColors.GRAY;
		public static var INPUT_FG:uint = BaseColors.WHITE;
		
		public static var OUTPUT_BG:uint = BaseColors.BLACK;
		public static var OUTPUT_FG:uint = BaseColors.WHITE;
		
		public static var FILTER_BG:uint = BaseColors.BLACK;
		public static var FILTER_FG:uint = BaseColors.WHITE;
		
		public static var INSPECTOR_BG:uint = BaseColors.DEEP_GREY;
		public static var INSPECTOR_FG:uint = BaseColors.WHITE;
		
		public static var BUTTON_ACTIVE_BG:uint = BaseColors.WHITE;
		public static var BUTTON_ACTIVE_FG:uint = BaseColors.BLACK;
		public static var BUTTON_INACTIVE_BG:uint = BaseColors.BLACK;
		public static var BUTTON_INACTIVE_FG:uint = BaseColors.WHITE;
		
		public static var INSPECTOR_TAB_HEADER_BG:uint = BaseColors.BLACK;
		public static var INSPECTOR_TAB_HEADER_FG:uint = BaseColors.WHITE;
		public static var INSPECTOR_TAB_CONTENT_BG:uint = BaseColors.BLACK;
		public static var INSPECTOR_TAB_CONTENT_FG:uint = BaseColors.WHITE;
		
		public static var INSPECTOR_PROPERTY_FIELD_BG:uint = BaseColors.BLACK;
		public static var INSPECTOR_PROPERTY_FIELD_NAME_BG:uint = BaseColors.BLACK;
		public static var INSPECTOR_PROPERTY_FIELD_NAME_FG:uint = BaseColors.WHITE;
		
		public static var INSPECTOR_PROPERTY_CONTROL_FIELD_BG:uint = BaseColors.BLACK;
		public static var INSPECTOR_PROPERTY_CONTROL_FIELD_FG:uint = BaseColors.WHITE;
		public static var BUTTON_BORDER:uint = BaseColors.GRAY;
		
		public static function update(sm:StyleManager):void {
			CORE = sm.theme.data.core.back;
			ENABLED = sm.theme.data.labels.enabled;
			DISABLED = sm.theme.data.labels.disabled;
			LOCKED = sm.theme.data.labels.locked;
			TOOLTIP_FG = sm.theme.data.tooltip.fore;
			TOOLTIP_BG = sm.theme.data.tooltip.back;
			DROPDOWN_BORDER = sm.theme.data.dropdowns.border;
			DROPDOWN_FG_ACTIVE = sm.theme.data.dropdowns.active.fore;
			DROPDOWN_BG_ACTIVE = sm.theme.data.dropdowns.active.back;
			DROPDOWN_FG_INACTIVE = sm.theme.data.dropdowns.inactive.fore;
			DROPDOWN_BG_INACTIVE = sm.theme.data.dropdowns.inactive.back;
			SCALEHANDLE_BG = sm.theme.data.core.back; //TODO: Some modifier for alphas
			SCROLLBAR_FG = sm.theme.data.scrollbars.fore;
			SCROLLBAR_BG = sm.theme.data.scrollbars.back;
			TREEVIEW_FG = sm.theme.data.inspector.treeview.fore;
			TREEVIEW_BG = sm.theme.data.inspector.treeview.back;
			MAINSPLIT_DRAG_BAR_BG = sm.theme.data.core.back;
			ASSISTANT_FG = sm.theme.data.assistant.fore;
			ASSISTANT_BG = sm.theme.data.assistant.back;
			HEADER_FG = sm.theme.data.consoleheader.fore;
			HEADER_BG = sm.theme.data.consoleheader.back;
			INPUT_FG = sm.theme.data.input.fore;
			INPUT_BG = sm.theme.data.input.back;
			INPUT_BORDER = sm.theme.data.input.border;
			OUTPUT_FG = sm.theme.data.output.fore;
			OUTPUT_BG = sm.theme.data.output.back;
			FILTER_FG = sm.theme.data.filters.fore;
			FILTER_BG = sm.theme.data.filters.back;
			INSPECTOR_FG = sm.theme.data.inspector.fore;
			INSPECTOR_BG = sm.theme.data.inspector.back;
			INSPECTOR_TAB_HEADER_FG = sm.theme.data.inspector.propertyview.tabs.header.fore;
			INSPECTOR_TAB_HEADER_BG = sm.theme.data.inspector.propertyview.tabs.header.back;
			INSPECTOR_TAB_CONTENT_FG = sm.theme.data.inspector.propertyview.tabs.content.fore;
			INSPECTOR_TAB_CONTENT_BG = sm.theme.data.inspector.propertyview.tabs.content.back;
			INSPECTOR_PROPERTY_FIELD_BG = sm.theme.data.inspector.propertyview.fields.back;
			INSPECTOR_PROPERTY_FIELD_NAME_FG = sm.theme.data.inspector.propertyview.fields.name.fore;
			INSPECTOR_PROPERTY_FIELD_NAME_BG = sm.theme.data.inspector.propertyview.fields.name.back;
			INSPECTOR_PROPERTY_CONTROL_FIELD_FG = sm.theme.data.inspector.propertyview.fields.value.fore;
			INSPECTOR_PROPERTY_CONTROL_FIELD_BG = sm.theme.data.inspector.propertyview.fields.value.back;
			
			SCALEHANDLE_BG = sm.theme.data.scalehandle.back;
			SCALEHANDLE_FG = sm.theme.data.scalehandle.fore;
			
			BUTTON_ACTIVE_FG = sm.theme.data.buttons.active.fore;
			BUTTON_ACTIVE_BG = sm.theme.data.buttons.active.back;
			BUTTON_INACTIVE_FG = sm.theme.data.buttons.inactive.fore;
			BUTTON_INACTIVE_BG = sm.theme.data.buttons.inactive.back;
			BUTTON_BORDER = sm.theme.data.buttons.border;
		}
	}

}
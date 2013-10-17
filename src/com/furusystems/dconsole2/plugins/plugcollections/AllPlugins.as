package com.furusystems.dconsole2.plugins.plugcollections
{
	import com.furusystems.dconsole2.core.plugins.IPluginBundle;
	import com.furusystems.dconsole2.plugins.BatchRunnerUtil;
	import com.furusystems.dconsole2.plugins.BugReporterUtil;
	import com.furusystems.dconsole2.plugins.BytearrayHexdumpUtil;
	import com.furusystems.dconsole2.plugins.ChainsawConnectorUtil;
	import com.furusystems.dconsole2.plugins.ClassFactoryUtil;
	import com.furusystems.dconsole2.plugins.colorpicker.ColorPickerUtil;
	import com.furusystems.dconsole2.plugins.CommandMapperUtil;
	import com.furusystems.dconsole2.plugins.controller.ControllerUtil;
	import com.furusystems.dconsole2.plugins.dialog.DialogUtil;
	import com.furusystems.dconsole2.plugins.FontUtil;
	import com.furusystems.dconsole2.plugins.inspectorviews.inputmonitor.InputMonitorUtil;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.PropertyViewUtil;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.TreeViewUtil;
	import com.furusystems.dconsole2.plugins.invokegesture.InvokeGestureUtil;
	import com.furusystems.dconsole2.plugins.JSONParserUtil;
	import com.furusystems.dconsole2.plugins.JSRouterUtil;
	import com.furusystems.dconsole2.plugins.LogFileUtil;
	import com.furusystems.dconsole2.plugins.MathUtil;
	import com.furusystems.dconsole2.plugins.measurebracket.MeasurementBracketUtil;
	import com.furusystems.dconsole2.plugins.mediatester.MediaTesterUtil;
	import com.furusystems.dconsole2.plugins.MouseUtil;
	import com.furusystems.dconsole2.plugins.PerformanceTesterUtil;
	import com.furusystems.dconsole2.plugins.ProductInfoUtil;
	import com.furusystems.dconsole2.plugins.ScreenshotUtil;
	import com.furusystems.dconsole2.plugins.SelectionHistoryUtil;
	import com.furusystems.dconsole2.plugins.StageUtil;
	import com.furusystems.dconsole2.plugins.StatsOutputUtil;
	import com.furusystems.dconsole2.plugins.SystemInfoUtil;
	/**
	 * Collection of all available plugins
	 * @author Andreas Roenning
	 */
	public class AllPlugins implements IPluginBundle
	{
		private var _plugins:Vector.<Class>;
		public function AllPlugins()
		{
			_plugins = Vector.<Class>([
				BytearrayHexdumpUtil,
				ProductInfoUtil,
				MeasurementBracketUtil,
				ColorPickerUtil,
				ClassFactoryUtil,
				DialogUtil,
				ControllerUtil,
				LogFileUtil,
				BatchRunnerUtil,
				MediaTesterUtil,
				ScreenshotUtil,
				FontUtil,
				JSRouterUtil,
				MouseUtil,
				SystemInfoUtil,
				StatsOutputUtil,
				PerformanceTesterUtil,
				CommandMapperUtil,
				JSONParserUtil,
				PropertyViewUtil,
				StageUtil,
				ChainsawConnectorUtil,
				InvokeGestureUtil,
				InputMonitorUtil,
				BugReporterUtil,
				TreeViewUtil,
				SelectionHistoryUtil,
				MathUtil
			]);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IPluginBundle */
		
		public function get plugins():Vector.<Class>
		{
			return _plugins;
		}
		
	}

}
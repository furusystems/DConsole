package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.BitmapData;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	import nochump.util.zip.ZipOutput;
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class BugReporterUtil implements IDConsolePlugin
	{
		private var _console:IConsole;
		private var _screenshotUtil:ScreenshotUtil;
		private var _logFileUtil:LogFileUtil;
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String 
		{
			return "Saves a screenshot and a log as a ZIP file";
		}
		
		public function initialize(pm:PluginManager):void 
		{
			_console = pm.console;
			_console.createCommand("bugReport", saveBugReport, "Bug tracking", "Saves a screenshot and a log as a ZIP file. Depends on ScreenshotUtil and LogFileUtil.");
			_screenshotUtil = pm.getPluginByType(ScreenshotUtil) as ScreenshotUtil;
			_logFileUtil = pm.getPluginByType(LogFileUtil) as LogFileUtil;
			
		}
		
		private function saveBugReport():void 
		{
			_console.print("Building bug report");
			var screen:BitmapData = _screenshotUtil.getScreenshot(_console.view.root);
			var log:XML = _logFileUtil.buildLogXML();
			var dateString:String = "";
			var d:Date = new Date();
			var zipFileName:String = "BugReport_" + d.toDateString() + ".zip";
			//trace(zipFileName);
			
			var fileData:ByteArray = new ByteArray();
			fileData.writeUTF(log);
			var zipOut:ZipOutput = new ZipOutput();
			// Add entry to zip
			var ze:ZipEntry = new ZipEntry("log.xml");
			zipOut.putNextEntry(ze);
			zipOut.write(fileData);
			zipOut.closeEntry();
			
			fileData = _screenshotUtil.getPNG(screen);
			ze = new ZipEntry("screenshot.png");
			zipOut.putNextEntry(ze);
			zipOut.write(fileData);
			zipOut.closeEntry();
						
			// end the zip
			zipOut.finish();
			// access the zip data
			var zipData:ByteArray = zipOut.byteArray;
			var f:FileReference = new FileReference();
			f.save(zipData, zipFileName);
			
			_console.print("Saved bug report");
		}
		
		public function shutdown(pm:PluginManager):void 
		{
			_console = null;
			_screenshotUtil = null;
			_logFileUtil = null;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get dependencies():Vector.<Class> 
		{
			var d:Vector.<Class> = new Vector.<Class>();
			d.push(ScreenshotUtil, LogFileUtil);
			return d;
		}
		
	}

}
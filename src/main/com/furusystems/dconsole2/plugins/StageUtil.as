package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class StageUtil implements IDConsolePlugin
	{
		private var _console:IConsole;
		
		public function StageUtil() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String
		{
			return "Adds commands for common stage operations";
		}
		
		public function initialize(pm:PluginManager):void
		{
			_console = pm.console;
			_console.createCommand("alignStage", alignStage, "Stage", "Sets stage.align to TOP_LEFT and stage.scaleMode to NO_SCALE");
			_console.createCommand("setFrameRate", setFramerate, "Stage", "Sets stage.frameRate");
			_console.createCommand("toggleFullscreen", toggleFullscreen, "FullscreenUtil", "Toggles stage.displayState between FULL_SCREEN and NORMAL");

		}
		private function setFramerate(rate:int = 60):void
		{
			_console.view.stage.frameRate = rate;
			_console.print("Framerate set to " + _console.view.stage.frameRate, ConsoleMessageTypes.SYSTEM);
		}
		private function alignStage():void
		{
			_console.view.stage.align = StageAlign.TOP_LEFT;
			_console.view.stage.scaleMode = StageScaleMode.NO_SCALE;
			_console.print("StageAlign set to TOP_LEFT, StageScaleMode set to NO_SCALE", ConsoleMessageTypes.SYSTEM);
		}
		private function toggleFullscreen():void {
			switch(_console.view.stage.displayState) {
				case StageDisplayState.FULL_SCREEN:
				_console.view.stage.displayState = StageDisplayState.NORMAL;
				break;
				case StageDisplayState.NORMAL:
				_console.view.stage.displayState = StageDisplayState.FULL_SCREEN;
				break;
			}
		}
		
		public function shutdown(pm:PluginManager):void
		{
			_console.removeCommand("alignStage");
			_console.removeCommand("setFrameRate");
			_console.removeCommand("toggleFullscreen");
			_console = null;
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
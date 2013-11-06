package com.furusystems.dconsole2.plugins 
{
	import flash.system.System;
	import flash.utils.getTimer;
	import com.furusystems.dconsole2.core.gui.maindisplay.assistant.Assistant;
	import com.furusystems.dconsole2.core.plugins.IUpdatingDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning, Mr.doob
	 */
	public class StatsOutputUtil implements IUpdatingDConsolePlugin
	{
		private var _assistant:Assistant;

		private var _timer : uint;
		private var _fps : uint;
		private var _ms : uint;
		private var _ms_prev : uint;
		private var _mem : Number;
		private var _mem_max : Number;
		private var _fpsStat:Number = 0;
		public function StatsOutputUtil() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String
		{
			return "Outputs memory use and FPS to idle Assistant";
		}
		
		public function initialize(pm:PluginManager):void
		{
			_assistant = pm.console.view.assistant;
			_fpsStat;
		}
		
		public function shutdown(pm:PluginManager):void
		{
			_assistant = null;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IUpdatingDConsolePlugin */
		
		public function update(pm:PluginManager):void
		{
			if (!_assistant.visible) return;
			var out:String = getStats();
			if (_assistant.idle) {
				_assistant.setWeakText(out);
			}
		}
		
		/**
		 * Cannibalized from hires stats
		 */
		private function getStats():String
		{
			var output:String = "";
			_timer = getTimer();
			if( _timer - 1000 > _ms_prev )
			{
				_ms_prev = _timer;
				_mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				_mem_max = _mem_max > _mem ? _mem_max : _mem;
				_fpsStat = _fps;
				_fps = 0;
			}
			_fps++;
			
			output += "FPS: " + _fpsStat + "/" + _assistant.stage.frameRate;
			output += " MS: " + (_timer - _ms);
			output += " MEM(mb): " + _mem + "/" + _mem_max;
			_ms = _timer;
			
			return output;
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
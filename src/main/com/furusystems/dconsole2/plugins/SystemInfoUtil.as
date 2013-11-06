package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.IConsole;
	import flash.system.Capabilities;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class SystemInfoUtil implements IDConsolePlugin
	{
		private var _console:IConsole;
		
		public function SystemInfoUtil() 
		{
			
		}
		
		private function getCapabilities():void
		{
			_console.print("System capabilities info:",ConsoleMessageTypes.SYSTEM);
			_console.print("\tCapabilities.avHardwareDisable : "+Capabilities.avHardwareDisable);
			_console.print("\tCapabilities.hasAccessibility : "+Capabilities.hasAccessibility);
			_console.print("\tCapabilities.hasAudio : "+Capabilities.hasAudio);
			_console.print("\tCapabilities.hasAudioEncoder : "+Capabilities.hasAudioEncoder);
			_console.print("\tCapabilities.hasEmbeddedVideo : "+Capabilities.hasEmbeddedVideo);
			_console.print("\tCapabilities.hasIME : "+Capabilities.hasIME);
			_console.print("\tCapabilities.hasMP3 : "+Capabilities.hasMP3);
			_console.print("\tCapabilities.hasPrinting : "+Capabilities.hasPrinting);
			_console.print("\tCapabilities.hasScreenBroadcast : "+Capabilities.hasScreenBroadcast);
			_console.print("\tCapabilities.hasStreamingAudio : "+Capabilities.hasStreamingAudio);
			_console.print("\tCapabilities.hasStreamingVideo : "+Capabilities.hasStreamingVideo);
			_console.print("\tCapabilities.hasTLS : "+Capabilities.hasTLS);
			_console.print("\tCapabilities.hasVideoEncoder : "+Capabilities.hasVideoEncoder);
			_console.print("\tCapabilities.isDebugger : "+Capabilities.isDebugger);
			_console.print("\tCapabilities.language : "+Capabilities.language);
			_console.print("\tCapabilities.localFileReadDisable : "+Capabilities.localFileReadDisable);
			_console.print("\tCapabilities.manufacturer : "+Capabilities.manufacturer);
			_console.print("\tCapabilities.os : "+Capabilities.os);
			_console.print("\tCapabilities.pixelAspectRatio : "+Capabilities.pixelAspectRatio);
			_console.print("\tCapabilities.playerType : "+Capabilities.playerType);
			_console.print("\tCapabilities.screenColor : "+Capabilities.screenColor);
			_console.print("\tCapabilities.screenDPI : "+Capabilities.screenDPI);
			_console.print("\tCapabilities.screenResolutionX : "+Capabilities.screenResolutionX);
			_console.print("\tCapabilities.screenResolutionY : "+Capabilities.screenResolutionY);
			_console.print("\tCapabilities.version : "+Capabilities.version);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String
		{
			return "Adds commands for inspecting system and player capabilities";
		}
		
		public function initialize(pm:PluginManager):void
		{
			_console = pm.console;
			_console.createCommand("capabilities", getCapabilities, "SystemInfoUtil", "Prints the system capabilities");
		}
		
		public function shutdown(pm:PluginManager):void
		{
			pm.console.removeCommand("capabilities");
			_console = null;
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
package com.furusystems.dconsole2.plugins 
{
	import com.adobe.serialization.json.JSON;
	import com.furusystems.dconsole2.core.plugins.IParsingDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class JSONParserUtil implements IParsingDConsolePlugin
	{
		
		public function JSONParserUtil() 
		{
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IParsingDConsolePlugin */
		
		public function parse(data:String):*
		{
			var firstChar:String = data.charAt(0);
			switch(firstChar) {
				case "[":
				case "{":
					try {
						var ret:* = com.adobe.serialization.json.JSON.decode(data);
						return ret;
					}catch (e:Error) {
						return null;
					}
				break;
			}
			return null;
		}
		
		public function initialize(pm:PluginManager):void
		{
			
		}
		
		public function shutdown(pm:PluginManager):void
		{
			
		}
		
		public function get descriptionText():String
		{
			return "Adds JSON parsing of command arguments";
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
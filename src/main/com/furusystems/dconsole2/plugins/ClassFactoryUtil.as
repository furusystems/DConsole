package com.furusystems.dconsole2.plugins 
{
	import flash.utils.getDefinitionByName;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ClassFactoryUtil implements IDConsolePlugin
	{
		
		public function ClassFactoryUtil() 
		{
			
		}
		
		public function getClassByName(str:String):Class {
			return getDefinitionByName(str) as Class;
		}
		private function make(className:String, ...args):*{
			var c:Class = getClassByName(className);
			switch (args.length)
			{
				case 1:
				return new c(args[0]);
				case 2:
				return new c(args[0], args[1]);
				case 3:
				return new c(args[0], args[1], args[2]);
				case 4:
				return new c(args[0], args[1], args[2], args[3]);
				case 5:
				return new c(args[0], args[1], args[2], args[3], args[4]);
				case 6:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5]);
				case 7:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
				case 8:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
				case 9:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
				case 10:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
				case 11:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
				case 12:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
				case 13:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]);
				case 14:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]);
				case 15:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14]);
				case 16:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15]);
				case 17:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16]);
				case 18:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17]);
				case 19:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18]);
				case 20:
				return new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19]);
				default:
				return new c();
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void
		{
			pm.console.createCommand("new", make, "ClassFactoryUtil", "Creates a new instance of a specified class by its qualified name (ie package.ClassName). Hard capped to 20 args.");
			pm.console.createCommand("getClass", getClassByName, "ClassFactoryUtil", "Returns a reference to the Class object of the specified classname");
		}
		
		public function shutdown(pm:PluginManager):void
		{
			pm.console.removeCommand("new");
			pm.console.removeCommand("getClass");
		}
		
		public function get descriptionText():String
		{
			return "Enables the creation of class instances, and access to class types from 'getDefinitionByName'";
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
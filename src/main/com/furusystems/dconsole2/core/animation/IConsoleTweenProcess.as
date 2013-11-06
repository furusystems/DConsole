package com.furusystems.dconsole2.core.animation {
	
	/**
	 * Describes a tweening process usable with the ConsoleTweener
	 * @author Andreas Roenning
	 */
	public interface IConsoleTweenProcess {
		function stop():void;
		function get object():Object;
		function set object(ob:Object):void;
	}

}
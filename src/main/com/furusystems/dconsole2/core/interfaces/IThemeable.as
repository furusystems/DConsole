package com.furusystems.dconsole2.core.interfaces {
	import com.furusystems.messaging.pimp.MessageData;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public interface IThemeable {
		function onThemeChange(md:MessageData):void;
	}

}
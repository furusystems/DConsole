package com.furusystems.dconsole2.core.input {
	import flash.events.KeyboardEvent;
	
	/**
	 * KeyboardList Interface
	 *
	 * @author Cristobal Dabed
	 * @version 0.1
	 */
	internal interface KeyboardList {
		function onKeyUp(event:KeyboardEvent):Boolean;
		function onKeyDown(event:KeyboardEvent):Boolean;
		function removeAll():void;
		function isEmpty():Boolean;
	}
}
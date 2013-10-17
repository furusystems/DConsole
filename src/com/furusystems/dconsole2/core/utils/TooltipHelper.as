package com.furusystems.dconsole2.core.utils {
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class TooltipHelper {
		public static var messaging:PimpCentral;
		private static var helpmap:Dictionary = new Dictionary();
		
		public static function map(object:InteractiveObject, text:String):void {
			helpmap[object] = text;
			object.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			object.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		static private function onMouseOut(e:MouseEvent):void {
			messaging.send(Notifications.TOOLTIP_HIDE_REQUEST);
		}
		
		static private function onMouseOver(e:MouseEvent):void {
			messaging.send(Notifications.TOOLTIP_SHOW_REQUEST, helpmap[e.currentTarget]);
		}
	
	}

}
package com.furusystems.dconsole2.core.gui.events 
{
	import com.furusystems.dconsole2.core.gui.DropDownOption;
	import flash.events.Event;
	
	/**
	 * Event used with dropdown menus
	 * @author Andreas Roenning
	 */
	public class DropDownEvent extends Event 
	{
		
		public static const SELECTION:String = "selection";
		public var selectedOption:DropDownOption;
		public function DropDownEvent(type:String = SELECTION, option:DropDownOption = null) 
		{ 
			super(type, false, false);
			selectedOption = option;
			
		} 
		
		public override function clone():Event 
		{ 
			var e:DropDownEvent = new DropDownEvent(type, selectedOption);
			return e;
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DropDownEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
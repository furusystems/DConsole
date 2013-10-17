package com.furusystems.dconsole2.core.interfaces {
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public interface IScrollable {
		function scrollByDelta(x:Number, y:Number):void;
		function get scrollX():Number;
		function get scrollY():Number;
		function set scrollX(n:Number):void;
		function set scrollY(n:Number):void;
		function get maxScrollX():Number;
		function get maxScrollY():Number;
		function get scrollXEnabled():Boolean;
		function get scrollYEnabled():Boolean;
	}

}
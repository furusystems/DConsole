package com.furusystems.dconsole2.core.gui.layout {
	import flash.geom.Rectangle;
	
	/**
	 * Describes an object by a rectangle that can be contained in a layout container and influenced by its layout
	 * @author Andreas Roenning
	 */
	public interface IContainable {
		function onParentUpdate(allotedRect:Rectangle):void;
		function get rect():Rectangle;
		function set x(n:Number):void;
		function get x():Number;
		function set y(n:Number):void;
		function get y():Number;
		function get minHeight():Number;
		function get minWidth():Number;
	}

}
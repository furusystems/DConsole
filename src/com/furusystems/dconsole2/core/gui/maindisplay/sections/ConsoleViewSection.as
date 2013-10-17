package com.furusystems.dconsole2.core.gui.maindisplay.sections {
	import com.furusystems.dconsole2.core.DSprite;
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ConsoleViewSection extends DSprite implements IContainable {
		
		public function ConsoleViewSection() {
		
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle):void {
		
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function get minHeight():Number {
			return 0;
		}
		
		public function get minWidth():Number {
			return 0;
		}
		
		public function get rect():Rectangle {
			return getRect(parent);
		}
	
	}

}
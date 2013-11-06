package com.furusystems.dconsole2.core.gui.layout {
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * A cell containing two cells along a vertical split
	 * @author Andreas Roenning
	 */
	public class VerticalSplit extends Cell {
		public var topCell:Cell = new Cell();
		public var botCell:Cell = new Cell();
		protected var _splitRatio:Number = 0.5;
		private var creationTime:Number = getTimer();
		
		public function VerticalSplit() {
			addChild(topCell);
			addChild(botCell);
		}
		
		public function get splitRatio():Number {
			return _splitRatio;
		}
		
		public function set splitRatio(value:Number):void {
			_splitRatio = value;
			var r:Rectangle = rect.clone();
			r.height = rect.height * _splitRatio;
			topCell.onParentUpdate(r);
			r.y = rect.y + rect.height * _splitRatio;
			r.height = rect.height * (1 - _splitRatio);
			botCell.onParentUpdate(r);
		}
		
		override protected function onRectangleChanged():void {
			super.onRectangleChanged();
			splitRatio = _splitRatio;
		}
		
		override public function onParentUpdate(allotedRect:Rectangle):void {
			_splitRatio = Math.sin((getTimer() - creationTime) / 1000) * 0.5 + 0.5;
			rect = allotedRect;
		}
	
	}

}
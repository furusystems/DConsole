package com.furusystems.dconsole2.core.gui.layout {
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * A cell containing two cells along a horizontal split
	 * @author Andreas Roenning
	 */
	public class HorizontalSplit extends Cell {
		public var leftCell:Cell = new Cell();
		public var rightCell:Cell = new Cell();
		protected var _splitRatio:Number = 0.5;
		
		public function HorizontalSplit() {
			addChild(leftCell);
			addChild(rightCell);
		}
		
		public function get splitRatio():Number {
			return _splitRatio;
		}
		
		public function set splitRatio(value:Number):void {
			_splitRatio = Math.max(0, Math.min(1, value));
			var r:Rectangle = rect.clone();
			
			var leftWidth:int = rect.width * _splitRatio;
			var rightWidth:Number = rect.width - leftWidth;
			var remainder:Number = rect.width - (leftWidth + rightWidth);
			if (remainder > 0) {
				leftWidth += remainder;
			} else if (remainder < 0) {
				rightWidth -= remainder;
			}
			
			var leftRect:Rectangle = new Rectangle(0, 0, leftWidth, rect.height);
			var rightRect:Rectangle = new Rectangle(leftWidth, 0, rightWidth, rect.height);
			
			leftCell.onParentUpdate(leftRect);
			rightCell.onParentUpdate(rightRect);
		}
		
		public function setSplitPos(splitPosition:int):Number {
			splitPosition = int(Math.max(minWidth, Math.min(splitPosition, width)));
			splitRatio = splitPosition / width;
			return splitRatio;
		}
		
		public function getSplitPos():int {
			return splitRatio * width;
		}
		
		override protected function onRectangleChanged():void {
			splitRatio = _splitRatio;
		}
		
		override public function onParentUpdate(allotedRect:Rectangle):void {
			rect = allotedRect;
		}
	
	}

}
package com.furusystems.dconsole2.core {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class DSprite extends Sprite {
		private static const tempPoint:Point = new Point();
		
		public var data:*;
		
		public static const ALIGN_TOP:uint = 0;
		public static const ALIGN_BOT:uint = 1;
		public static const ALIGN_LEFT:uint = 2;
		public static const ALIGN_RIGHT:uint = 3;
		public static const ALIGN_TOP_RIGHT:uint = 4;
		public static const ALIGN_TOP_LEFT:uint = 5;
		public static const ALIGN_BOT_RIGHT:uint = 6;
		public static const ALIGN_BOT_LEFT:uint = 7;
		public static const ALIGN_CENTER:uint = 8;
		
		public static const ADDMODE_ROW:uint = 0;
		public static const ADDMODE_COLUMN:uint = 1;
		public static const ADDMODE_GRID:uint = 2;
		
		public function DSprite() {
		
		}
		
		protected function nativeTrace(... args:Array):void {
			trace.apply(this, args);
		}
		
		/**
		 * Add a child directly at a certain position
		 * @param	d
		 * The DisplayObject to add
		 * @param	x
		 * X position
		 * @param	y
		 * Y position
		 * @param	centerVertically
		 * Center the object vertically by subtracting half its height from Y
		 * @param	centerHorizontally
		 * Center the object horizontally by subtracting half its width from X
		 * @return
		 * The added DisplayObject
		 */
		public function addChildAtPosition(d:DisplayObject, x:Number, y:Number, centerVertically:Boolean = false, centerHorizontally:Boolean = false):DisplayObject {
			d.x = x;
			if (centerHorizontally)
				d.x -= d.width >> 1;
			d.y = y;
			if (centerVertically)
				d.y -= d.height >> 1;
			return this.addChild(d);
		}
		
		/**
		 * Returns an array of first level child display objects
		 * @return an array of display objects
		 */
		public function getChildren():Array {
			var a:Array = [];
			for (var i:int = 0; i < numChildren; i++) {
				a.push(getChildAt(i));
			}
			return a;
		}
		
		public function alignChildren(alignType:int = ALIGN_TOP):void {
			var c:Array = getChildren();
			var alignValue:Number = 0;
			var rect:Rectangle = getRect(this);
			for (var i:int = 0; i < c.length; i++) {
				var d:DisplayObject = DisplayObject(c[i]);
				switch (alignType) {
					case ALIGN_BOT:
						d.y = rect.height - d.height;
						break;
					case ALIGN_TOP:
						d.y = 0;
						break;
					case ALIGN_LEFT:
						d.x = 0;
						break;
					case ALIGN_RIGHT:
						d.x = rect.width - d.width;
						break;
				}
			}
		}
		
		public function fromPoint(p:Point):void {
			x = p.x;
			y = p.y;
		}
		
		public function getPoint():Point {
			return new Point(x, y);
		}
		
		public function fromRect(rect:Rectangle):void {
			x = rect.x;
			y = rect.y;
			width = rect.width;
			height = rect.height;
		}
		
		/**
		 * Centers the sprite at a point
		 * @param	x
		 * X coord
		 * @param	y
		 * Y coord
		 * @param	interpolate
		 * Interpolate the move
		 */
		public function centerAt(x:Number, y:Number, interpolate:Boolean = false):void {
			tempPoint.x = x;
			tempPoint.y = y;
			alignWithPoint(tempPoint, ALIGN_CENTER);
		}
		
		/**
		 * Aligns the sprite to point p
		 * @param	p
		 * The point to align with
		 * @param	alignment
		 * The alignment type
		 */
		public function alignWithPoint(p:Point, alignment:uint):void {
			switch (alignment) {
				case ALIGN_BOT:
					x = p.x - width * .5;
					y = p.y - height;
					break;
				case ALIGN_BOT_LEFT:
					x = p.x;
					y = p.y - height;
					break;
				case ALIGN_BOT_RIGHT:
					x = p.x - width;
					y = p.y - height;
					break;
				case ALIGN_TOP:
					x = p.x - width * .5;
					y = p.y;
					break;
				case ALIGN_TOP_LEFT:
					x = p.x;
					y = p.y;
					break;
				case ALIGN_TOP_RIGHT:
					x = p.x - width;
					y = p.y;
					break;
				case ALIGN_LEFT:
					y = p.y - height * .5;
					x = p.x;
					break;
				case ALIGN_RIGHT:
					y = p.y - height * .5;
					x = p.x - width;
					break;
				case ALIGN_CENTER:
					y = p.y - height * .5;
					x = p.x - width * .5;
					break;
			}
		}
		
		/**
		 * Adds an array of display objects to the display list
		 * @param	children
		 * The array of children to add
		 * @param	addMode
		 * The way the children are added to the list, either as a row, a column or a grid (0,1,2 respectively)
		 * @param	margin
		 * The pixel margin between each column or row
		 * @param	startPos
		 * The pixel offset to start from
		 * @param	maxCol
		 * The max number of items per row
		 */
		public function addChildren(children:Array, addMode:int = -1, margin:int = 0, startPos:Point = null, maxCol:int = 5):Array {
			if (!startPos)
				startPos = new Point();
			var c1:int = 0;
			var c2:int = 0;
			var c3:int = 0;
			var ob:DisplayObject;
			switch (addMode) {
				case ADDMODE_COLUMN:
					for each (ob in children) {
						addChild(ob);
						ob.y = startPos.y + c1;
						ob.x = startPos.x;
						c1 += ob.height + margin;
					}
					break;
				case ADDMODE_ROW:
					for each (ob in children) {
						addChild(ob);
						ob.y = startPos.y;
						ob.x = startPos.x + c1;
						c1 += ob.width + margin;
					}
					break;
				case ADDMODE_GRID:
					for each (ob in children) {
						addChild(ob);
						ob.x = startPos.x + c1;
						ob.y = startPos.y + c2;
						c1 += ob.width + margin;
						c3++;
						if (c3 > maxCol) {
							c2 += ob.height + margin;
							c3 = c1 = 0;
						}
					}
					break;
				default:
					for each (ob in children) {
						addChild(ob);
					}
			}
			return children;
		}
		
		public function layoutChildren(addMode:int = -1, margin:int = 0, startPos:Point = null, maxCol:int = 5):void {
			var a:Array = getChildren();
			addChildren(a, addMode, margin, startPos, maxCol);
		}
		
		public function set xy(n:Number):void {
			x = y = n;
		}
		
		public function set scaleXY(n:Number):void {
			scaleX = scaleY = n;
		}
	
	}

}
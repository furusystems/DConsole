package com.furusystems.dconsole2.core.bitmap {
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * An implementation of bresenham's algorithm used with some drawing calls
	 * @author Andreas Roenning
	 */
	
	public final class Bresenham {
		private static const _XY:BresenhamSharedData = new BresenhamSharedData();
		
		public static function line_pixel(p1:Point, p2:Point, target:BitmapData, color:uint = 0):void {
			_XY.update(p1, p2);
			var y:int = _XY.y0;
			target.lock();
			target.setPixel(p1.x, p1.y, color);
			for (var x:int = _XY.x0; x < _XY.x1; x++) {
				if (_XY.steep) {
					target.setPixel(y, x, color);
				} else {
					target.setPixel(x, y, color);
				}
				_XY.error = _XY.error - _XY.deltay;
				if (_XY.error < 0) {
					y += _XY.ystep;
					_XY.error += _XY.deltax;
				}
			}
			target.setPixel(p2.x, p2.y, color);
			target.unlock();
		}
		
		public static function line_pixel32(p1:Point, p2:Point, target:BitmapData, color:uint = 0xFF000000):void {
			_XY.update(p1, p2);
			var y:int = _XY.y0;
			target.lock();
			target.setPixel32(p1.x, p1.y, color);
			for (var x:int = _XY.x0; x < _XY.x1; x++) {
				if (_XY.steep) {
					target.setPixel32(y, x, color);
				} else {
					target.setPixel32(x, y, color);
				}
				_XY.error = _XY.error - _XY.deltay;
				if (_XY.error < 0) {
					y += _XY.ystep;
					_XY.error += _XY.deltax;
				}
			}
			target.setPixel32(p2.x, p2.y, color);
			target.unlock();
		}
		
		public static function line_stamp(p1:Point, p2:Point, target:BitmapData, stampSource:BitmapData, centerStamp:Boolean = true):void {
			if (centerStamp) {
				var offsetX:int = 0;
				var offsetY:int = 0;
				offsetX = stampSource.width * .5;
				offsetY = stampSource.height * .5;
				p1.offset(-offsetX, -offsetY);
				p2.offset(-offsetX, -offsetY);
			}
			_XY.update(p1, p2);
			var y:int = _XY.y0;
			var targetPoint:Point = new Point();
			var targetPointInv:Point = new Point();
			target.lock();
			target.copyPixels(stampSource, stampSource.rect, p1, null, null, true);
			for (var x:int = _XY.x0; x < _XY.x1; x++) {
				targetPoint.x = x;
				targetPoint.y = y;
				targetPointInv.x = y;
				targetPointInv.y = x;
				if (_XY.steep) {
					target.copyPixels(stampSource, stampSource.rect, targetPointInv, null, null, true);
				} else {
					target.copyPixels(stampSource, stampSource.rect, targetPoint, null, null, true);
				}
				_XY.error = _XY.error - _XY.deltay;
				if (_XY.error < 0) {
					y += _XY.ystep;
					_XY.error += _XY.deltax;
				}
			}
			target.copyPixels(stampSource, stampSource.rect, p2, null, null, true);
			target.unlock();
		}
		
		public static function circle(p:Point, radius:int, target:BitmapData, color:uint = 0):void {
			var f:int = 1 - radius;
			var ddF_x:int = 1;
			var ddF_y:int = -2 * radius;
			var x:int = 0;
			var y:int = radius;
			var x0:int = p.x;
			var y0:int = p.y;
			
			target.lock();
			target.setPixel(x0, y0 + radius, color);
			target.setPixel(x0, y0 - radius, color);
			target.setPixel(x0 + radius, y0, color);
			target.setPixel(x0 - radius, y0, color);
			
			while (x < y) {
				if (f >= 0) {
					y--;
					ddF_y += 2;
					f += ddF_y;
				}
				x++;
				ddF_x += 2;
				f += ddF_x;
				target.setPixel(x0 + x, y0 + y, color);
				target.setPixel(x0 - x, y0 + y, color);
				target.setPixel(x0 + x, y0 - y, color);
				target.setPixel(x0 - x, y0 - y, color);
				target.setPixel(x0 + y, y0 + x, color);
				target.setPixel(x0 - y, y0 + x, color);
				target.setPixel(x0 + y, y0 - x, color);
				target.setPixel(x0 - y, y0 - x, color);
			}
			target.unlock();
		}
		
		public static function circle32(p:Point, radius:int, target:BitmapData, color:uint = 0xFF000000):void {
			var f:int = 1 - radius;
			var ddF_x:int = 1;
			var ddF_y:int = -2 * radius;
			var x:int = 0;
			var y:int = radius;
			var x0:int = p.x;
			var y0:int = p.y;
			
			target.lock();
			target.setPixel32(x0, y0 + radius, color);
			target.setPixel32(x0, y0 - radius, color);
			target.setPixel32(x0 + radius, y0, color);
			target.setPixel32(x0 - radius, y0, color);
			
			while (x < y) {
				if (f >= 0) {
					y--;
					ddF_y += 2;
					f += ddF_y;
				}
				x++;
				ddF_x += 2;
				f += ddF_x;
				target.setPixel32(x0 + x, y0 + y, color);
				target.setPixel32(x0 - x, y0 + y, color);
				target.setPixel32(x0 + x, y0 - y, color);
				target.setPixel32(x0 - x, y0 - y, color);
				target.setPixel32(x0 + y, y0 + x, color);
				target.setPixel32(x0 - y, y0 + x, color);
				target.setPixel32(x0 + y, y0 - x, color);
				target.setPixel32(x0 - y, y0 - x, color);
			}
			target.unlock();
		}
	}
}
import flash.geom.Point;

internal final class BresenhamSharedData {
	public var x0:int, x1:int, y0:int, y1:int, deltax:int, deltay:int, error:int, ystep:int;
	public var steep:Boolean;
	private var t1:int, t2:int, temp:int;
	
	public function update(p1:Point, p2:Point):void {
		t1 = p1.y - p2.y;
		t2 = p1.x - p2.x;
		steep = ((t1 ^ (t1 >> 31)) - (t1 >> 31)) > ((t2 ^ (t2 >> 31)) - (t2 >> 31));
		x0 = p2.x;
		x1 = p1.x;
		y0 = p2.y;
		y1 = p1.y;
		
		if (steep) {
			x0 ^= y0;
			y0 ^= x0;
			x0 ^= y0;
			
			x1 ^= y1;
			y1 ^= x1;
			x1 ^= y1;
		}
		if (x0 > x1) {
			x0 ^= x1;
			x1 ^= x0;
			x0 ^= x1;
			
			y0 ^= y1;
			y1 ^= y0;
			y0 ^= y1;
		}
		deltax = x1 - x0;
		temp = y1 - y0;
		deltay = (temp ^ (temp >> 31)) - (temp >> 31);
		error = deltax * .5;
		(y0 < y1) ? ystep = 1 : ystep = -1;
	}
}

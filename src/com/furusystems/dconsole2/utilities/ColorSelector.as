package com.furusystems.dconsole2.utilities {
	import com.boostworthy.geom.ColorBar;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class ColorSelector extends Sprite {
		private var colorBarBmp:BitmapData;
		
		public function ColorSelector(width:Number, height:Number) {
			colorBarBmp = new BitmapData(width, height, false, 0);
			colorBarBmp.draw(new ColorBar(width, height));
			addChild(new Bitmap(colorBarBmp));
		}
		
		public function lookUp(x:Number, y:Number):uint {
			return colorBarBmp.getPixel(Math.max(0, Math.min(width, x)), Math.max(0, Math.min(height, y)));
		}
	
	}

}
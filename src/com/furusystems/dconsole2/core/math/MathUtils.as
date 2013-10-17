package com.furusystems.dconsole2.core.math {
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class MathUtils {
		
		public function MathUtils() {
		
		}
		
		public static function random(from:Number = 0, to:Number = 1, round:Boolean = false):Number {
			var v:Number = from + Math.random() * (to - from);
			return round ? Math.round(v) : v;
		}
		
		public static function add(a:Number, b:Number):Number {
			return a + b;
		}
		
		public static function subtract(a:Number, b:Number):Number {
			return a - b;
		}
		
		public static function divide(a:Number, b:Number):Number {
			return a / b;
		}
		
		public static function multiply(a:Number, b:Number):Number {
			return a * b;
		}
	
	}

}
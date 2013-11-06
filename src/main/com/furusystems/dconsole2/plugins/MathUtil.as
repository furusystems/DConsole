package com.furusystems.dconsole2.plugins {
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class MathUtil implements IDConsolePlugin{
		
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
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void {
			pm.console.createCommand("random", random, "Math", "Return a random value between X and Y, as an int if the third arg is true");
			pm.console.createCommand("add", add, "Math", "Add X to Y");
			pm.console.createCommand("subtract", subtract, "Math", "Subtract Y from X");
			pm.console.createCommand("divide", divide, "Math", "Divide X with Y");
			pm.console.createCommand("multiply", multiply, "Math", "Multiply X with Y");
		}
		
		public function shutdown(pm:PluginManager):void {
			pm.console.removeCommand("random");
			pm.console.removeCommand("add");
			pm.console.removeCommand("subtract");
			pm.console.removeCommand("divide");
			pm.console.removeCommand("multiply");
		}
		
		public function get descriptionText():String {
			return "Basic math functions";
		}
		
		public function get dependencies():Vector.<Class> {
			return new Vector.<Class>();
		}
	
	}

}
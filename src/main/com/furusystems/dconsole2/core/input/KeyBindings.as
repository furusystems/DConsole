package com.furusystems.dconsole2.core.input {
	import flash.ui.Keyboard;
	
	/**
	 * Maintains a list of keyboard bindings.
	 * 	Wrapper for the Keyboard class, some extra options and adds set of default keycodes for the characters a-z.
	 *
	 * References:
	 *	- http://www.signar.se/blog/as-3-charcodes/
	 *
	 * @author Cristobal Dabed
	 * @version 0.2
	 */
	public final class KeyBindings {
		/* Modifiers */
		public static const NONE:uint = 0; // Special Modifier binding for when tracing keystroke characters only.
		public static const ALT:uint = 18; // Keyboard.ALTERNATE
		public static const SHIFT:uint = Keyboard.SHIFT;
		public static const CTRL:uint = Keyboard.CONTROL;
		public static const ALT_SHIFT:uint = 18 + Keyboard.SHIFT;
		public static const CTRL_ALT:uint = Keyboard.CONTROL + 18;
		public static const CTRL_SHIFT:uint = Keyboard.CONTROL + Keyboard.SHIFT;
		
		/* Keystrokes */
		// FN's
		public static const F1:uint = Keyboard.F1;
		public static const F2:uint = Keyboard.F2;
		public static const F3:uint = Keyboard.F3;
		public static const F4:uint = Keyboard.F4;
		public static const F5:uint = Keyboard.F5;
		public static const F6:uint = Keyboard.F6;
		public static const F7:uint = Keyboard.F7;
		public static const F8:uint = Keyboard.F8;
		public static const F9:uint = Keyboard.F9;
		public static const F10:uint = Keyboard.F10;
		public static const F11:uint = Keyboard.F11;
		public static const F12:uint = Keyboard.F12;
		public static const F13:uint = Keyboard.F13;
		public static const F14:uint = Keyboard.F14;
		public static const F15:uint = Keyboard.F15;
		
		// OPTIONS
		public static const ENTER:uint = Keyboard.ENTER; // can only be used as keystroke + 2 modifiers
		public static const TAB:uint = Keyboard.TAB; // can only be used as keystroke + 2 modifiers
		public static const ESC:uint = Keyboard.ESCAPE; // can only be used as keystroke + 1 modifier
		public static const SPACE:uint = Keyboard.SPACE; // must have at least on valid modifier.
		
		// Arrows
		public static const UP:uint = Keyboard.UP;
		public static const DOWN:uint = Keyboard.DOWN;
		public static const RIGHT:uint = Keyboard.RIGHT;
		public static const LEFT:uint = Keyboard.LEFT;
		
		// Nums
		public static const NUM_0:uint = Keyboard.NUMPAD_0;
		public static const NUM_1:uint = Keyboard.NUMPAD_1;
		public static const NUM_2:uint = Keyboard.NUMPAD_2;
		public static const NUM_3:uint = Keyboard.NUMPAD_3;
		public static const NUM_4:uint = Keyboard.NUMPAD_4;
		public static const NUM_5:uint = Keyboard.NUMPAD_5;
		public static const NUM_6:uint = Keyboard.NUMPAD_6;
		public static const NUM_7:uint = Keyboard.NUMPAD_7;
		public static const NUM_8:uint = Keyboard.NUMPAD_8;
		public static const NUM_9:uint = Keyboard.NUMPAD_9;
		
		// Ops
		public static const OP_ADD:uint = Keyboard.NUMPAD_ADD;
		public static const OP_SUB:uint = Keyboard.NUMPAD_SUBTRACT;
		public static const OP_DIV:uint = Keyboard.NUMPAD_DIVIDE;
		public static const OP_MUL:uint = Keyboard.NUMPAD_MULTIPLY;
		
		// Characters lowercase
		public static const a:uint = toCharCode("a");
		public static const b:uint = toCharCode("b");
		public static const c:uint = toCharCode("c");
		public static const d:uint = toCharCode("d");
		public static const e:uint = toCharCode("e");
		public static const f:uint = toCharCode("f");
		public static const g:uint = toCharCode("g");
		public static const h:uint = toCharCode("h");
		public static const i:uint = toCharCode("i");
		public static const j:uint = toCharCode("j");
		public static const k:uint = toCharCode("k");
		public static const l:uint = toCharCode("l");
		public static const m:uint = toCharCode("m");
		public static const n:uint = toCharCode("n");
		public static const o:uint = toCharCode("o");
		public static const p:uint = toCharCode("p");
		public static const q:uint = toCharCode("q");
		public static const r:uint = toCharCode("r");
		public static const s:uint = toCharCode("s");
		public static const t:uint = toCharCode("t");
		public static const u:uint = toCharCode("u");
		public static const v:uint = toCharCode("v");
		public static const x:uint = toCharCode("x");
		public static const y:uint = toCharCode("y");
		public static const z:uint = toCharCode("z");
		
		// Characters uppercase
		public static const A:uint = toKeyCode("A");
		public static const B:uint = toKeyCode("B");
		public static const C:uint = toKeyCode("C");
		public static const D:uint = toKeyCode("D");
		public static const E:uint = toKeyCode("E");
		public static const F:uint = toKeyCode("F");
		public static const G:uint = toKeyCode("G");
		public static const H:uint = toKeyCode("H");
		public static const I:uint = toKeyCode("I");
		public static const J:uint = toKeyCode("J");
		public static const K:uint = toKeyCode("K");
		public static const L:uint = toKeyCode("L");
		public static const M:uint = toKeyCode("M");
		public static const N:uint = toKeyCode("N");
		public static const O:uint = toKeyCode("O");
		public static const P:uint = toKeyCode("P");
		public static const Q:uint = toKeyCode("Q");
		public static const R:uint = toKeyCode("R");
		public static const S:uint = toKeyCode("S");
		public static const T:uint = toKeyCode("T");
		public static const U:uint = toKeyCode("U");
		public static const V:uint = toKeyCode("V");
		public static const X:uint = toKeyCode("X");
		public static const Y:uint = toKeyCode("Y");
		public static const Z:uint = toKeyCode("Z");
		
		/**
		 * To key code
		 *
		 * @param char The char value to get the char code for.
		 *
		 * @return
		 * 	Returns the char code for the character passed.
		 */
		public static function toCharCode(char:String):uint {
			return char.charCodeAt(0);
		}
		
		/**
		 * To char codes.
		 *
		 * @param value	The string values to retrieve the char codes for.
		 *
		 * @return
		 * 	Returns an array of the char codes from the passed string.
		 */
		public static function toCharCodes(value:String):Array {
			var keyCodes:Array = [];
			for (var i:int = 0, l:int = value.length; i < l; i++) {
				keyCodes.push(value.charCodeAt(i));
			}
			return keyCodes;
		}
		
		/**
		 * To key code
		 *
		 * @param char The char value to get the char code for.
		 *
		 * @return
		 * 	Returns the char code for the character passed.
		 */
		public static function toKeyCode(char:String):uint {
			return char.toUpperCase().charCodeAt(0);
		}
		
		/**
		 * To key codes
		 *
		 * @param value The string values to retrieve the key codes for.
		 *
		 * @return
		 * 	Returns an array of the key codes from the passed string.
		 */
		public static function toKeyCodes(value:String):Array {
			var keyCodes:Array = [];
			for (var i:int = 0, l:int = value.length; i < l; i++) {
				keyCodes.push(toKeyCode(value.charAt(i)));
			}
			return keyCodes;
		}
	}
}
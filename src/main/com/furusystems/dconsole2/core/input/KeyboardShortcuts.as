package com.furusystems.dconsole2.core.input {
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * Maintains a list of keyboard shortcuts and dispatches the callback function when a shortcut has been triggered.
	 *
	 * @author Andreas Roenning, Cristobal Dabed
	 * @version 0.1
	 */
	public final class KeyboardShortcuts implements KeyboardList {
		private static var INSTANCE:KeyboardShortcuts = null;
		private var keyboardShortcuts:Vector.<KeyboardShortcut> = new Vector.<KeyboardShortcut>();
		
		/* @group API */
		
		/**
		 * Instance
		 *
		 * @return
		 * 	Returns the singleton representation of this class.
		 */
		public static function get instance():KeyboardShortcuts {
			if (!INSTANCE) {
				INSTANCE = new KeyboardShortcuts();
			}
			return INSTANCE;
		}
		
		/**
		 * Add
		 *
		 * @param keystroke The keystroke an valid keycode
		 * @param modifier	The modifier can be either ALT, CTR, SHIFT or ALT+SHIFT, CTR+ALT. CTR+SHIFT
		 * @param callback	The callback function to call when the shortcut has been triggered.
		 * @param override	Wether to override an existing shortcut with the same name.
		 *
		 * @return
		 * 	Return true or false depending on wether the shortcut was successfully added or not.
		 */
		public function add(keystroke:uint, modifier:uint, callback:Function, override:Boolean = false, replaceAll:Boolean = true):Boolean {
			var success:Boolean;
			
			/*
			 *	Throw errors if.
			 *		1. Not an valid keystroke
			 *		2. Not an valid modifier.
			 *		3. Not an valid keystroke + modifier combination.
			 *		4. Not an valid callback.
			 */
			
			if (!validateKeystroke(keystroke)) {
				throw new Error("Invalid keystroke");
			}
			
			if (!validateModifier(modifier)) {
				throw new Error("Invalid modifier");
			}
			
			if (!validateKeystrokeWithModifier(keystroke, modifier)) {
				throw new Error("Invalid keystroke + modifier combination");
			}
			
			if (typeof(callback) != "function") {
				throw new Error("Invalid callback function");
			}
			
			if (replaceAll) {
				keyboardShortcuts = new Vector.<KeyboardShortcut>();
			}
			
			if (!has(keystroke, modifier)) {
				keyboardShortcuts.push(new KeyboardShortcut(keystroke, modifier, callback));
			} else if (override) {
				instance.removeKeyboardShortcut(keystroke, modifier);
				keyboardShortcuts.push(new KeyboardShortcut(keystroke, modifier, callback));
			}
			
			return success;
		}
		
		/**
		 * Remove
		 *
		 * @param keystroke The keystroke an valid keycode
		 * @param modifier	The modifier can be either ALT, CTR, SHIFT or ALT+SHIFT, CTR+ALT. CTR+SHIFT
		 *
		 * @return
		 * 	Return true or false depending on wether the shortcut was successfully removed or not.
		 */
		public function remove(keystroke:uint, modifier:uint):Boolean {
			var success:Boolean = false;
			if (!isEmpty()) {
				if (has(keystroke, modifier)) {
					var i:int = 0;
					for (var l:int = keyboardShortcuts.length; i < l; i++) {
						if (inKeyboardShortcut(keystroke, modifier, keyboardShortcuts[i])) {
							break;
						}
					}
					keyboardShortcuts.splice(i, 1);
				}
			}
			return success;
		}
		
		/**
		 * Has
		 *
		 * @return
		 * 	Returns true or false depending on wether the keystroke, modifier combination already exists or not.
		 */
		private function has(keystroke:uint, modifier:uint):Boolean {
			var success:Boolean = false;
			for (var i:int = 0, l:int = keyboardShortcuts.length; i < l; i++) {
				if (inKeyboardShortcut(keystroke, modifier, keyboardShortcuts[i])) {
					success = true;
					break;
				}
			}
			return success;
		}
		
		/**
		 * Remove All
		 */
		public function removeAll():void {
			if (!isEmpty()) {
				while (keyboardShortcuts.length > 0) {
					keyboardShortcuts.pop();
				}
			}
		}
		
		/**
		 * Is empty
		 *
		 * @return
		 * 	Returns true or false depending on wether there are any registered keyboard shortcuts or not.
		 */
		public function isEmpty():Boolean {
			return (keyboardShortcuts.length == 0 ? true : false);
		}
		
		/* @end */
		
		/* @group Delegates called directly by the KeyboardManager */
		// We could have added custom events but do not to save some resources while keyboard input should be as fast as possible.
		
		/**
		 * On key down.
		 *
		 * @param event The keyboard event.
		 */
		public function onKeyDown(event:KeyboardEvent):Boolean {
			var success:Boolean = false;
			if (!isEmpty()) {
				
				// Get the modifier
				var modifier:uint = getModifierFromKeyboardEvent(event);
				/*
				 * 1. Loop over the keyboard shortcuts, on the first keyboard shortcut that match the criteria break out, but make sure that it is released if one wants .
				 * 2. If the keyboard shortcut is in the state released trigger it and set the released state to false.
				 */
				var keyCode:uint = event.keyCode;
				var i:int = 0;
				for (var l:int = keyboardShortcuts.length; i < l; i++) {
					if (inKeyboardShortcut(keyCode, modifier, keyboardShortcuts[i])) {
						success = true;
						break;
					}
				}
				if (success) {
					if (keyboardShortcuts[i].released) {
						keyboardShortcuts[i].released = false;
						try {
							keyboardShortcuts[i].callback();
						} catch (error:Error) { /* suppress warning. */
						}
					}
				}
			}
			return success;
		}
		
		/**
		 * On key up.
		 *
		 * @param event The keyboard event.
		 */
		public function onKeyUp(event:KeyboardEvent):Boolean {
			var success:Boolean = false;
			if (!isEmpty()) {
				// Get the modifier
				var modifier:uint = getModifierFromKeyboardEvent(event);
				var keyCode:uint = event.keyCode;
				
				/*
				 * Loop over the keyboard shortcuts and release the respective if they have the keystroke and are not already released.
				 */
				for (var i:int = 0, l:int = keyboardShortcuts.length; i < l; i++) {
					if ((keyCode == keyboardShortcuts[i].keystroke) && !keyboardShortcuts[i].released) {
						keyboardShortcuts[i].released = success = true;
					}
				}
			}
			return success;
		}
		
		/**
		 * Validate kestroke with modifier
		 *
		 * @param kestroke 	The keystroke
		 * @param modifier	The modifier
		 *
		 * @return
		 * 	Returns true or false depending on wether the keystroke + modifier is a valid combination.
		 */
		public function validateKeystrokeWithModifier(keystroke:uint, modifier:uint):Boolean {
			var success:Boolean = true;
			/*
			 * 1. ENTER must satisfy at least 2 modifiers but can not be used with ALT_SHIFT since it is a reserved keystroke i Windows for Fullscreen.
			 * 2. TAB must satisfy at least 2 modifier and can only used with ALT_SHIFT.
			 * 3. ESC	can only have 1 modifier
			 * 3. FN*   can not have a  modifier
			 * 4. SPACE must have at least one modifier.
			 */
			if (keystroke == KeyBindings.ENTER) {
				if (modifier != KeyBindings.ALT_SHIFT) {
					success = isCombinedModifier(modifier);
				}
			}
			
			if (keystroke == KeyBindings.TAB) {
				success = (modifier == KeyBindings.ALT_SHIFT);
			}
			
			if (keystroke == KeyBindings.ESC) {
				success = !isCombinedModifier(modifier);
			}
			
			if (modifier == KeyBindings.NONE) {
				success = !isKeystrokeFN(keystroke);
			}
			
			if ((keystroke == KeyBindings.SPACE)) {
				success = (modifier != KeyBindings.NONE);
			}
			return success;
		}
		
		/* @end */
		
		/* @group Private Functions */
		
		/**
		 * Validate keystroke
		 *
		 * @param keystroke	The keystroke to validate.
		 */
		private function validateKeystroke(keystroke:uint):Boolean {
			var success:Boolean = true;
			switch (keystroke) {
				case KeyBindings.ALT:
				case KeyBindings.SHIFT:
				case KeyBindings.CTRL:
				case Keyboard.BACKSPACE:
				case Keyboard.CAPS_LOCK:
				case Keyboard.INSERT:
				case Keyboard.DELETE:
				case Keyboard.HOME:
				case Keyboard.PAGE_UP:
				case Keyboard.PAGE_DOWN:
					success = false;
					break;
			}
			return success;
		}
		
		/**
		 * Validate shortcut
		 *
		 * @param shortcut	The shortcut to validate.
		 *
		 * @return
		 * 	Returns true or false depedending on wether it was an valid shortcut or not.
		 */
		private function validateModifier(modifier:uint):Boolean {
			var success:Boolean = false;
			switch (modifier) {
				case KeyBindings.NONE:
				case KeyBindings.ALT:
				case KeyBindings.SHIFT:
				case KeyBindings.CTRL:
				case KeyBindings.ALT_SHIFT:
				case KeyBindings.CTRL_ALT:
				case KeyBindings.CTRL_SHIFT:
					success = true;
					break;
			}
			return success;
		}
		
		/**
		 * Is combined modifier.
		 *
		 * @param modifier The modifier
		 *
		 * @return
		 * 	Returns true or false depending on wether the modifier is a combined modifier or not.
		 */
		private function isCombinedModifier(modifier:uint):Boolean {
			var success:Boolean = false;
			switch (modifier) {
				case KeyBindings.ALT_SHIFT:
				case KeyBindings.CTRL_ALT:
				case KeyBindings.CTRL_SHIFT:
					success = true;
					break;
			}
			return success;
		}
		
		/**
		 * Is keystroke FN
		 *
		 * @param keystroke	The keystroke
		 *
		 * @return
		 * 	Returns true or false depending on wether the keeystroke is a FN key code or not.
		 */
		private function isKeystrokeFN(modifier:uint):Boolean {
			var success:Boolean = false;
			switch (modifier) {
				case KeyBindings.F1:
				case KeyBindings.F2:
				case KeyBindings.F3:
				case KeyBindings.F4:
				case KeyBindings.F5:
				case KeyBindings.F6:
				case KeyBindings.F7:
				case KeyBindings.F8:
				case KeyBindings.F9:
				case KeyBindings.F10:
				case KeyBindings.F11:
				case KeyBindings.F12:
				case KeyBindings.F13:
				case KeyBindings.F14:
				case KeyBindings.F15:
					success = true;
					break;
			}
			return success;
		}
		
		/**
		 * Add Keyboard shortcut
		 *
		 * @param keystroke The keystroke code
		 * @param modifier	The modifier value.
		 */
		private function addKeyboardShortcut(keystroke:uint, modifier:uint, callback:Function):void {
			keyboardShortcuts.push(new KeyboardShortcut(keystroke, modifier, callback));
		}
		
		/**
		 * Remove Keyboard shortcut
		 *
		 * @param keystroke The keystroke code
		 * @param modifier	The modifier value.
		 */
		private function removeKeyboardShortcut(keystroke:uint, modifier:uint):void {
			var i:int = 0;
			for (var l:int = keyboardShortcuts.length; i < l; i++) {
				if (inKeyboardShortcut(keystroke, modifier, keyboardShortcuts[i])) {
					break;
				}
			}
			keyboardShortcuts.splice(i, 1);
		}
		
		/**
		 * In keyboard shortcut
		 *
		 * @param keystroke The keystroke value.
		 * @param modifier	The modifier value.
		 * @param keyboardShortcut	The keyboard shortcut to check on.
		 *
		 * @returns
		 * 	Returns true or false depending on wether the keyboard shortcut contains the keystroke, modifier combination.
		 */
		private function inKeyboardShortcut(keystroke:uint, modifier:uint, keyboardShortcut:KeyboardShortcut):Boolean {
			return ((keyboardShortcut.keystroke == keystroke) && (keyboardShortcut.modifier == modifier));
		}
		
		/**
		 * Get modifier from keyboard event.
		 *
		 * @param event	The keyboard event to parse.
		 */
		private function getModifierFromKeyboardEvent(event:KeyboardEvent):uint {
			var modifier:uint = KeyBindings.NONE;
			if (event.altKey) {
				modifier += KeyBindings.ALT;
			}
			if (event.ctrlKey) {
				modifier += KeyBindings.CTRL;
			}
			if (event.shiftKey) {
				modifier += Keyboard.SHIFT;
			}
			return modifier;
		}
	
	/* @end */
	}
}
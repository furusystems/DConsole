package com.furusystems.dconsole2.core.input {
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	/**
	 * Maintains a list of keyboard shortcuts and dispatches the callback function when a shortcut has been triggered.
	 *
	 * @author Andreas Roenning, Cristobal Dabed
	 * @version 0.3
	 */
	public final class KeyboardManager extends EventDispatcher {
		/*  Variables */
		private static var INSTANCE:KeyboardManager;
		private var keyboardSource:InteractiveObject = null;
		
		/* @group  API */
		
		/**
		 * Gets a singleton instance of the input manager
		 * @return
		 */
		public static function get instance():KeyboardManager {
			if (!INSTANCE) {
				INSTANCE = new KeyboardManager();
			}
			return INSTANCE;
		}
		
		/**
		 * Start tracking keyboard events
		 * If already tracking, previous event listeners will be removed
		 * @param	eventSource
		 * The object whose events to respond to (typically stage)
		 */
		public function setup(eventSource:InteractiveObject):void {
			try {
				//shutdown();
			} catch (e:Error) {
			}
			//eventSource.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown,false,Number.POSITIVE_INFINITY,true);
			//eventSource.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp, false, Number.POSITIVE_INFINITY, true);
			//keyboardSource = eventSource;
		}
		
		/**
		 * Stop tracking keyboard events
		 */
		public function shutdown():void {
			//keyboardSource.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			//keyboardSource.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			//keyboardSource = null;
			KeyboardSequences.instance.removeAll();
			KeyboardShortcuts.instance.removeAll();
		}
		
		// Keyboard Shortcuts Functions
		/**
		 * Add keyboard shortcut
		 *
		 * @param keystroke The keystroke an valid keycode
		 * @param modifier	The modifier can be either ALT, CTR, SHIFT or ALT+SHIFT, CTR+ALT. CTR+SHIFT
		 * @param callback	The callback function to call when the shortcut has been triggered.
		 * @param override	Wether to override an existing shortcut with the same name.
		 *
		 * @return
		 * 	Return true or false depending on wether the shortcut was successfully added or not.
		 */
		public function addKeyboardShortcut(keystroke:uint, modifier:uint, callback:Function, override:Boolean = false):Boolean {
			return KeyboardShortcuts.instance.add(keystroke, modifier, callback, override);
		}
		
		/**
		 * Remove shortcut
		 *
		 * @param name	The name of the keyboard shortcut to remove.
		 *
		 * @return
		 * 	Returns true or false depending on wether it managed to release the shortcut or not.
		 */
		public function removeKeyboardShortcut(keystroke:uint, modifier:uint):Boolean {
			return KeyboardShortcuts.instance.remove(keystroke, modifier);
		}
		
		/**
		 * Remove all
		 *
		 * @param source	Optional source to remove bind listen
		 *
		 * @return
		 * 	Returns true or false depending on wether it managed release all the shortcuts or not.
		 */
		public function removeAll(source:Object = null):void {
			KeyboardSequences.instance.removeAll();
			KeyboardShortcuts.instance.removeAll();
		}
		
		/**
		 * Validate Keyboard Shortcut
		 *
		 * @param keystroke The keystroke an valid keycode
		 * @param modifier	The modifier can be either ALT, CTR, SHIFT or ALT+SHIFT, CTR+ALT. CTR+SHIFT
		 *
		 * @return
		 * 	Returns true or false wether the keyboard shortcut is valid or not.
		 */
		public function validateKeyboardShortcut(keystroke:uint, modifier:uint):Boolean {
			return KeyboardShortcuts.instance.validateKeystrokeWithModifier(keystroke, modifier);
		}
		
		// Keyboard Sequences Functions.
		/**
		 * Add keyboard sequence.
		 *
		 * @param keyCodes	The list of keycodes to trigger a callback.
		 * @param callback	The callback function to call.
		 * @param override	Optional override for an existing keyboard sequence with the new function.
		 */
		public function addKeyboardSequence(keyCodes:Array, callback:Function, override:Boolean = false):Boolean {
			return KeyboardSequences.instance.add(keyCodes, callback, override);
		}
		
		/**
		 * Remove keyboard sequence.
		 *
		 * @param keyCodes	The keyCodes to stop listening on.
		 *
		 * @return
		 * 	Returns true or false depending on wether it successfully removed the keyCode sequence from the list or not.
		 */
		public function removeKeyboardSequence(keyCodes:Array):Boolean {
			return KeyboardSequences.instance.remove(keyCodes);
		}
		
		/**
		 * Validate Keyboard Sequence
		 *
		 * @param keyCodes The keyCodes to validate
		 *
		 * @return
		 * 	Returns true or false wether the keyboard sequence is valid or not.
		 */
		public function validateKeyboardSequence(keyCodes:Array):Boolean {
			return KeyboardSequences.instance.validateKeyboardSequence(keyCodes);
		}
		
		/* @end */
		
		/* @group Events */
		
		/**
		 * Handle key down.
		 *
		 * @param event	The keyboard event.
		 */
		public function handleKeyDown(event:KeyboardEvent):void {
			if (KeyboardSequences.instance.onKeyDown(event) || KeyboardShortcuts.instance.onKeyDown(event)) {
				event.stopImmediatePropagation();
				event.stopPropagation();
				event.preventDefault();
			}
		}
		
		/**
		 * Handle Key up.
		 *
		 * @param event The keyboard event
		 */
		public function handleKeyUp(event:KeyboardEvent):void {
			KeyboardSequences.instance.onKeyUp(event);
			KeyboardShortcuts.instance.onKeyUp(event);
		}
	
	/* @end */
	}

}
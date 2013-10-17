package com.furusystems.dconsole2.core.input
{
	/**
	 * Keyboardshortcut
	 * POAO class for a keyboard shortcut used and manipulated by the KeyboardShortcutsManager class only.
	 * 
	 * @author Cristobal Dabed
	 * @version 0.1
	 */ 
	public final class KeyboardShortcut 
	{
		public var keystroke:uint;
		public var modifier:uint;
		public var callback:Function;
		public var released:Boolean = true;
		public function KeyboardShortcut(keystroke:uint, modifier:uint, callback:Function)
		{
			this.keystroke = keystroke;
			this.modifier = modifier;
			this.callback = callback;
		}
	}
}
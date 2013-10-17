package com.furusystems.dconsole2.core.input
{
	/**
	 * KeyboardSequence
	 * POAO class for a keyboard sequence used and manipulated by the KeyboardSequencesManager class only.
	 * 
	 * @author Cristobal Dabed
	 * @version 0.1
	 */ 
	public final class KeyboardSequence
	{
		public var keyCodes:Array;
		public var callback:Function;
		public var keystrokes:Array;
		public function KeyboardSequence(keyCodes:Array, callback:Function)
		{
			this.keyCodes = keyCodes.concat(); // must use concat to make a shallow copy ref: http://help.adobe.com/en_US/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7ee7.html.
			this.callback = callback;
			this.keystrokes = keyCodes.concat(); // same here.
		}
	}
}
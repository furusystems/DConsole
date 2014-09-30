package com.furusystems.dconsole2 {
	import com.furusystems.dconsole2.core.gui.debugdraw.DebugDraw;
	import com.furusystems.dconsole2.core.gui.maindisplay.ConsoleView;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.events.Event;
	
	/**
	 * @author Andreas Roenning
	 */
	public interface IConsole {
		/**
		 * Get a pointer to the visual component of the console
		 * Add this to your root to get started
		 */
		function get view():ConsoleView;
		/**
		 * Show the console
		 */
		function show():void;
		/**
		 * Hide the console
		 */
		function hide():void;
		/**
		 * Toggles between showing and hiding
		 */
		function toggleDisplay():void;
		/**
		 * Execute a command statement
		 * @param	statement The statement to execute
		 * @param	echo Wether the statement should be output to the log
		 * @return The statement's return value, if any
		 */
		function executeStatement(statement:String, echo:Boolean = false):*;
		/**
		 * Select a new console scope
		 * @param	target
		 */
		function select(target:*):void;
		/**
		 * Set console visibility
		 */
		function get visible():Boolean;
		function set visible(b:Boolean):void;
		/**
		 * Set the default input callback. This function is called with a command statement in the case that the console doesn't understand it.
		 * Set to null to cancel this behavior out
		 */
		function set defaultInputCallback(f:Function):void;
		function get defaultInputCallback():Function;
		/**
		 * Print a message
		 * @param	str The message string
		 * @param	type The message type, one of ConsoleMessageTypes
		 * @param	tag The message tag
		 */
		function print(str:String, type:String = "Info", tag:String = ""):void;
		/**
		 * Change the invoking keyboard shortcut
		 * @param	keystroke
		 * @param	modifier
		 */
		function changeKeyboardShortcut(keystroke:uint, modifier:uint):void;
		/**
		 * Use this function to print events
		 * @example addEventListener(Event.ADDED_TO_STAGE,DConsole.onEvent);
		 * @param	e
		 */
		function onEvent(e:Event):void;
		/**
		 * Clear the log
		 */
		function clear():void;
		/**
		 * Create a new command
		 * @param	keyword The keyword. Must be unique.
		 * @param	func The function to map
		 * @param	category The command group: This is used to categorize commands.
		 * @param	helpText Any assisting text to display in the assistant
		 */
		function createCommand(keyword:String, func:Function, category:String = "Application", helpText:String = ""):void;
		/**
		 * Remove a command by its associated keyword
		 * @param	keyword
		 */
		function removeCommand(keyword:String):void;
		/**
		 * Set the header text of the console. Useful for displaying app version, title etc
		 * @param	title
		 */
		function setHeaderText(title:String):void;
		/**
		 * Set the overriding callback. This callback is called with ALL console input until cleared.
		 * @param	callback
		 */
		function setOverrideCallback(callback:Function):void;
		/**
		 * Removes the overriding callback
		 */
		function clearOverrideCallback():void;
		
		/**
		 * Lock the output: No new messages will be drawn
		 */
		function lockOutput():void;
		/**
		 * Unlock the output: New messages will be drawn, and the buffer and view will be synchronized.
		 */
		function unlockOutput():void;
		
		function setTheme(colors:XML, theme:XML):void;
		function getTheme():Array;
		
		/**
		 * Get the debugDraw utility (work in progress)
		 */
		function get debugDraw():DebugDraw;
		
		/**
		 * Get the internal messaging central
		 */
		function get messaging():PimpCentral;
		
		/**
		 * Get the full console log as a string
		 */
		function getLogString():String;
		
		/**
		 * Print the stack trace up until where this method was called
		 */
		function stackTrace():void;
		
		/**
		 * Update the current scope to reflect any recent changes
		 */
		function refresh():void;
		
		/**
		 * Retrieve the instance of a loaded plugin (if it exists)
		 * @param	type
		 * @return An IDConsolePlugin
		 */
		function getPluginInstance(type:Class):IDConsolePlugin;
	}

}
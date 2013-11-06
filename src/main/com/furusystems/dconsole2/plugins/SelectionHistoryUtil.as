package com.furusystems.dconsole2.plugins 
{
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class SelectionHistoryUtil implements IDConsolePlugin
	{
		private var _pm:PluginManager;
		private var _stack:Array;
		private var _doingSelection:Boolean = false;
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void 
		{
			_pm = pm;
			pm.console.createCommand("back", stepBack, "Introspection", "Steps back to the previously selected scope");
			_stack = [];
			pm.messaging.addCallback(Notifications.SCOPE_CHANGE_BEGUN, onScopeChangeBegun);
			pm.messaging.addCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChangeComplete);
		}
		
		private function onScopeChangeComplete():void 
		{
			if (_pm.scopeManager.currentScope.targetObject == _pm.scopeManager.getRoot()) {
				_stack = []; //Hax.
			}
			_doingSelection = false;
		}
		
		private function onScopeChangeBegun():void 
		{
			if(!_doingSelection){
				_stack.push(_pm.scopeManager.currentScope.targetObject); //Store where we are now
			}
		}
		
		private function stepBack():void 
		{
			if (_stack.length > 0) {
				_doingSelection = true;
				_pm.scopeManager.setScope(_stack.pop());
			}else {
				_doingSelection = false;
				_pm.scopeManager.selectBaseScope();
			}
		}
		
		public function shutdown(pm:PluginManager):void 
		{
			_stack = [];
			pm.console.removeCommand("back");
			pm.messaging.removeCallback(Notifications.SCOPE_CHANGE_BEGUN, onScopeChangeBegun);
			pm.messaging.removeCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChangeComplete);
			_pm = null;
		}
		
		public function get descriptionText():String 
		{
			return "Stores a linear stack of selections, letting you always step back to the previous selection";
		}
		
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
		public function get selectionStack():Array 
		{
			return _stack;
		}
		
	}

}
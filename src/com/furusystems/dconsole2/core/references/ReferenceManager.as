package com.furusystems.dconsole2.core.references {
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ReferenceManager {
		private var referenceDict:Dictionary = new Dictionary(true);
		private var console:DConsole;
		private var scopeManager:ScopeManager;
		private var uidPool:uint = 0;
		
		private function get uid():uint {
			return uidPool++;
		}
		
		//TODO: Add autocomplete for reference names
		public function ReferenceManager(console:DConsole, scopeManager:ScopeManager) {
			this.scopeManager = scopeManager;
			this.console = console;
			console.messaging.addCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChanged);
		}
		
		private function onScopeChanged(md:MessageData):void {
			referenceDict["this"] = IntrospectionScope(md.data).targetObject;
		}
		
		public function clearReferenceByName(name:String):void {
			try {
				delete(referenceDict[name])
				console.print("Cleared reference " + name, ConsoleMessageTypes.SYSTEM);
				printReferences();
			} catch (e:Error) {
				console.print("No such reference", ConsoleMessageTypes.ERROR);
			}
		}
		
		public function getReferenceByName(target:*, id:String = null):void {
			var t:Object;
			try {
				t = scopeManager.getScopeByName(target);
			} catch (e:Error) {
				t = target;
			}
			if (!t) {
				throw new Error("Invalid target");
			}
			if (!id) {
				id = "ref" + uid;
			}
			referenceDict[id] = t;
			printReferences();
		}
		
		public function getReference(id:String = null):void {
			if (!id) {
				id = "ref" + uid;
			}
			referenceDict[id] = scopeManager.currentScope.targetObject;
			printReferences();
		}
		
		public function createReference(o:*):void {
			var id:String = "r" + uid;
			referenceDict[id] = o;
			printReferences();
		}
		
		public function clearReferences():void {
			referenceDict = new Dictionary(true);
			console.print("References cleared", ConsoleMessageTypes.SYSTEM);
		}
		
		public function printReferences():void {
			console.print("Stored references: ");
			for (var b:*in referenceDict) {
				console.print("	" + b.toString() + " : " + referenceDict[b].toString());
			}
		}
		
		public function setScopeByReferenceKey(key:String):void {
			if (referenceDict[key]) {
				scopeManager.setScope(referenceDict[key]);
			} else {
				throw new Error("No such reference");
			}
		}
		
		public function parseForReferences(args:Array):Array {
			//return args;
			for (var i:int = 0; i < args.length; i++) {
				var key:String = args[i];
				if (referenceDict[key] != null) {
					if (referenceDict[key] is Function) {
						args[i] = referenceDict[key]();
					} else {
						args[i] = referenceDict[key];
					}
				} else {
					try {
						var force:Boolean = false;
						if (key.charAt(0) == "@") {
							key = key.slice(1, key.length);
							force = true;
						}
						var tmp:* = scopeManager.getScopeByName(key);
						if (tmp is Function || force) {
							args[i] = tmp;
						}
					} catch (e:Error) {
						//args[i] = null;
					}
				}
			}
			return args;
		}
	
	}

}
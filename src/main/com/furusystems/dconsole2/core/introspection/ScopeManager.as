package com.furusystems.dconsole2.core.introspection {
	import com.furusystems.dconsole2.core.commands.CommandManager;
	import com.furusystems.dconsole2.core.introspection.descriptions.*;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.text.autocomplete.AutocompleteManager;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ScopeManager extends EventDispatcher {
		public static const SEARCH_METHODS:int = 0;
		public static const SEARCH_ACCESSORS:int = 1;
		public static const SEARCH_CHILDREN:int = 2;
		
		private var _currentScope:IntrospectionScope;
		private var _previousScope:IntrospectionScope;
		
		private var console:DConsole;
		private var autoCompleteManager:AutocompleteManager;
		private var commandManager:CommandManager;
		
		public function ScopeManager(console:DConsole, autoCompleteManager:AutocompleteManager) {
			this.console = console;
			this.autoCompleteManager = autoCompleteManager;
			console.messaging.addCallback(Notifications.REQUEST_PROPERTY_CHANGE_ON_SCOPE, onPropertyChangeRequest);
			console.messaging.addCallback(Notifications.SCOPE_CHANGE_REQUEST_FROM_PROPERTY, onPropertyScopeChangeRequest);
			console.messaging.addCallback(Notifications.SCOPE_CHANGE_REQUEST_FROM_CHILD_NAME, onChildNameScopeChangeRequest);
		}
		
		public function initialize():void {
			_currentScope = createScope({});
		}
		
		private function onChildNameScopeChangeRequest(md:MessageData):void {
			try {
				setScope(DisplayObjectContainer(_currentScope.targetObject).getChildByName(String(md.data)));
			} catch (e:Error) {
				console.print("Null reference, couldn't select target.", ConsoleMessageTypes.ERROR);
			}
		}
		
		private function onPropertyScopeChangeRequest(md:MessageData):void {
			try {
				setScope(_currentScope.targetObject[md.data]);
			} catch (e:Error) {
				console.print("Null reference, couldn't select target.", ConsoleMessageTypes.ERROR);
			}
		}
		
		private function onPropertyChangeRequest(md:MessageData):void {
			_currentScope.targetObject[md.data.name] = md.data.newValue;
			console.messaging.send(Notifications.PROPERTY_CHANGE_ON_SCOPE, _currentScope, this);
		}
		
		public function createScope(o:*, justReturn:Boolean = false):IntrospectionScope {
			if (!o)
				throw new ArgumentError("Invalid scope");
			var c:IntrospectionScope = new IntrospectionScope();
			c.children = TreeUtils.getChildren(o);
			c.accessors = InspectionUtils.getAccessors(o);
			c.methods = InspectionUtils.getMethods(o);
			c.variables = InspectionUtils.getVariables(o);
			c.targetObject = o;
			c.xml = describeType(o);
			c.qualifiedClassName = getQualifiedClassName(o);
			c.inheritanceChain = InspectionUtils.getInheritanceChain(o);
			c.interfaces = InspectionUtils.getInterfaces(o);
			
			if (justReturn)
				return c;
			c.autoCompleteDict = InspectionUtils.getAutoCompleteDictionary(o);
			_currentScope = c;
			console.messaging.send(Notifications.SCOPE_CREATED, _currentScope, this);
			return _currentScope;
		}
		
		public function setScope(o:*, force:Boolean = false, printResults:Boolean = true):void {
			if (o is Stage && DConsole.STAGE_SAFE_MODE) {
				console.print("Stage safe mode active, access prohibited", ConsoleMessageTypes.ERROR);
				return; //TODO: Stage selections really shouldn't be disallowed. But Stage object is so weird :-/
			}
			if (o is DConsole && DConsole.CONSOLE_SAFE_MODE) {
				console.print("Console safe mode active, access prohibited", ConsoleMessageTypes.ERROR);
				return;
			}
			//if(currentScope.targetObject===o){
			//if (force&&printResults) {
			//printScope();
			//printDownPath();
			//}
			//return;
			//}
			console.messaging.send(Notifications.SCOPE_CHANGE_BEGUN, _currentScope, this);
			try {
				createScope(o);
				autoCompleteManager.scopeDict = currentScope.autoCompleteDict;
			} catch (e:Error) {
				throw e;
			}
			if (printResults) {
				printScope();
				printDownPath();
			}
			console.messaging.send(Notifications.SCOPE_CHANGE_COMPLETE, _currentScope, this);
		}
		
		public function getScopeByName(str:String):* {
			try {
				if (currentScope.targetObject[str]) {
					return currentScope.targetObject[str];
				} else
					throw new Error();
			} catch (e:Error) {
				try {
					if (currentScope.targetObject is DisplayObjectContainer) {
						var tmp:DisplayObject = currentScope.targetObject.getChildByName(str);
						if (tmp != null)
							return tmp;
					}
				} catch (e:Error) {
				}
			}
			throw new Error("No such scope");
		}
		
		public function getRoot():DisplayObject {
			return console.root;
		}
		
		public function get currentScope():IntrospectionScope {
			return _currentScope;
		}
		
		public function up():void {
			if (!_currentScope) {
				throw new Error("No current scope; cannot switch to parent");
			}
			if (_currentScope.targetObject is DisplayObject) {
				setScope(_currentScope.targetObject.parent);
			} else {
				throw new Error("Current scope is not a DisplayObject; cannot switch to parent");
			}
		}
		
		private function traverseFor(obj:Object, name:String):Object {
			
			throw new Error("Not found");
		}
		
		public function setScopeByName(str:String):void {
			if (str.indexOf(".") > -1) {
				//path
				var found:Boolean = false;
				var split:Array = str.split(".");
				for (var i:int = 0; i < split.length; i++) {
					setScope(getScopeByName(split[i]), false, i == split.length - 1);
				}
				
			} else {
				//name
				try {
					setScope(getScopeByName(str));
				} catch (e:Error) {
					throw e;
				}
			}
		}
		
		public function printMethods():void {
			var m:Vector.<MethodDesc> = currentScope.methods;
			console.print("	methods:");
			var i:int;
			for (i = 0; i < m.length; i++) {
				var md:MethodDesc = m[i];
				console.print("		" + md.name + " : " + md.returnType);
			}
		}
		
		public function printVariables():void {
			var a:Vector.<VariableDesc> = currentScope.variables;
			var cv:*;
			console.print("	variables: " + a.length);
			var i:int
			for (i = 0; i < a.length; i++) {
				var vd:VariableDesc = a[i];
				console.print("		" + vd.name + ": " + vd.type);
				try {
					cv = currentScope.targetObject[vd.name];
					console.print("			value: " + ((cv is ByteArray) ? "[ByteArray]" : cv.toString()));
				} catch (e:Error) {
					
				}
			}
			var b:Vector.<AccessorDesc> = currentScope.accessors;
			console.print("	accessors: " + b.length);
			for (i = 0; i < b.length; i++) {
				var ad:AccessorDesc = b[i];
				console.print("		" + ad.name + ": " + ad.type);
				try {
					cv = currentScope.targetObject[ad.name];
					console.print("			value: " + ((cv is ByteArray) ? "[ByteArray]" : cv.toString()));
				} catch (e:Error) {
					
				}
			}
		}
		
		public function printChildren():void {
			var c:Vector.<ChildScopeDesc> = currentScope.children;
			if (c.length < 1)
				return;
			console.print("	children: " + c.length);
			for (var i:int = 0; i < c.length; i++) {
				var cc:ChildScopeDesc = c[i];
				console.print("		" + cc.name + " : " + cc.type);
			}
		}
		
		public function printDownPath():void {
			printChildren();
			printComplexObjects();
		}
		
		public function printComplexObjects():void {
			var a:Vector.<VariableDesc> = currentScope.variables;
			var cv:*;
			if (a.length < 1)
				return;
			var i:int
			var out:Array = [];
			for (i = 0; i < a.length; i++) {
				var vd:VariableDesc = a[i];
				switch (vd.type) {
					case "Number":
					case "Boolean":
					case "String":
					case "int":
					case "uint":
					case "Array":
						continue;
				}
				out.push("		" + vd.name + ": " + vd.type);
			}
			console.print("	complex types: " + out.length);
			if (out.length > 0) {
				for (i = 0; i < out.length; i++) {
					console.print(out[i]);
				}
			}
		}
		
		public function printScope():void {
			if (currentScope.targetObject is ByteArray) {
				console.print("scope : [ByteArray]");
			} else {
				console.print("scope : " + currentScope.targetObject.toString());
			}
		}
		
		public function setPropertyOnObject(propertyName:String, arg:*):* {
			if (arg == "true") {
				arg = true;
			} else if (arg == "false") {
				arg = false;
			}
			try {
				currentScope.targetObject[propertyName] = arg;
			} catch (e:Error) {
				console.print("Property '" + propertyName + "' could not be set", ConsoleMessageTypes.ERROR);
			}
			try {
				return currentScope.targetObject[propertyName];
			} catch (e:Error) {
				return null;
			}
		}
		
		public function getPropertyOnObject(propertyName:String):String {
			return currentScope.targetObject[propertyName].toString();
		}
		
		public function getPropertyValueOnObject(propertyName:String):* {
			return currentScope.targetObject[propertyName];
		}
		
		public function selectBaseScope():void {
			setScope(console.parent);
		}
		
		public function callMethodOnScope(... args:Array):* {
			var cmd:Function = args.shift();
			return commandManager.callMethodWithArgs(cmd, args);
		}
		
		public function updateScope():void {
			setScope(currentScope.targetObject, true);
		}
		
		public function doSearch(search:String, searchMode:int = SEARCH_METHODS):Vector.<String> {
			var result:Vector.<String> = new Vector.<String>;
			var s:String = search.toLowerCase();
			var i:int;
			switch (searchMode) {
				case SEARCH_ACCESSORS:
					for (i = currentScope.accessors.length; i--; ) {
						var a:AccessorDesc = currentScope.accessors[i];
						if (a.name.toLowerCase().indexOf(s, 0) > -1) {
							result.push(a.name);
						}
					}
					for (i = currentScope.variables.length; i--; ) {
						var v:VariableDesc = currentScope.variables[i];
						if (v.name.toLowerCase().indexOf(s, 0) > -1) {
							result.push(v.name);
						}
					}
					break;
				case SEARCH_METHODS:
					for (i = currentScope.methods.length; i--; ) {
						var m:MethodDesc = currentScope.methods[i];
						if (m.name.toLowerCase().indexOf(s, 0) > -1) {
							result.push(m.name);
						}
					}
					break;
				case SEARCH_CHILDREN:
					for (i = currentScope.children.length; i--; ) {
						var c:ChildScopeDesc = currentScope.children[i];
						if (c.name.toLowerCase().indexOf(s, 0) > -1) {
							result.push(c.name);
						}
					}
					break;
			}
			return result;
		}
		
		public function describeObject(o:Object):IntrospectionScope {
			return createScope(o, true);
		}
		
		public function setCommandMgr(commandManager:CommandManager):void {
			this.commandManager = commandManager;
		}
	
	}

}
package com.furusystems.dconsole2 {
	//{ imports
	import com.furusystems.dconsole2.core.commands.CommandManager;
	import com.furusystems.dconsole2.core.commands.ConsoleCommand;
	import com.furusystems.dconsole2.core.commands.FunctionCallCommand;
	import com.furusystems.dconsole2.core.commands.IntrospectionCommand;
	import com.furusystems.dconsole2.core.DSprite;
	import com.furusystems.dconsole2.core.errors.CommandError;
	import com.furusystems.dconsole2.core.errors.ConsoleAuthError;
	import com.furusystems.dconsole2.core.errors.ErrorStrings;
	import com.furusystems.dconsole2.core.gui.debugdraw.DebugDraw;
	import com.furusystems.dconsole2.core.gui.DockingGuides;
	import com.furusystems.dconsole2.core.gui.maindisplay.assistant.Assistant;
	import com.furusystems.dconsole2.core.gui.maindisplay.ConsoleView;
	import com.furusystems.dconsole2.core.gui.maindisplay.filtertabrow.FilterTabRow;
	import com.furusystems.dconsole2.core.gui.maindisplay.input.InputField;
	import com.furusystems.dconsole2.core.gui.maindisplay.output.OutputField;
	import com.furusystems.dconsole2.core.gui.maindisplay.toolbar.ConsoleToolbar;
	import com.furusystems.dconsole2.core.gui.ScaleHandle;
	import com.furusystems.dconsole2.core.gui.ToolTip;
	import com.furusystems.dconsole2.core.helpmanager.HelpManager;
	import com.furusystems.dconsole2.core.input.KeyBindings;
	import com.furusystems.dconsole2.core.input.KeyboardManager;
	import com.furusystems.dconsole2.core.input.KeyHandlerResult;
	import com.furusystems.dconsole2.core.introspection.InspectionUtils;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.logmanager.DConsoleLog;
	import com.furusystems.dconsole2.core.logmanager.DLogFilter;
	import com.furusystems.dconsole2.core.logmanager.DLogManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.output.ConsoleMessage;
	import com.furusystems.dconsole2.core.output.ConsoleMessageRepeatMode;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.persistence.PersistenceManager;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.references.ReferenceManager;
	import com.furusystems.dconsole2.core.security.ConsoleLock;
	import com.furusystems.dconsole2.core.style.StyleManager;
	import com.furusystems.dconsole2.core.text.autocomplete.AutocompleteDictionary;
	import com.furusystems.dconsole2.core.text.autocomplete.AutocompleteManager;
	import com.furusystems.dconsole2.core.text.TextUtils;
	import com.furusystems.dconsole2.core.utils.StringUtil;
	import com.furusystems.dconsole2.core.Version;
	import com.furusystems.dconsole2.logging.ConsoleLogBinding;
	import com.furusystems.logging.slf4as.Logging;
	import com.furusystems.messaging.pimp.Message;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	//}
	/**
	 * ActionScript 3 logger, commandline interface and utility platform
	 * @author Andreas Roenning
	 * @author Cristobal Dabed
	 * @author Furu systems
	 */
	public class DConsole extends DSprite implements IConsole {
		
		//{ members
		public var ignoreBlankLines:Boolean = true;
		
		private var _initialized:Boolean = false;
		private var _autoCompleteManager:AutocompleteManager;
		private var _globalDictionary:AutocompleteDictionary = new AutocompleteDictionary();
		private var _styleManager:StyleManager;
		private var _referenceManager:ReferenceManager;
		private var _scopeManager:ScopeManager;
		private var _commandManager:CommandManager;
		private var _toolTip:ToolTip;
		private var _visible:Boolean = false;
		private var _isVisible:Boolean = true; //TODO: Fix naming ambiguity; _isVisible refers to the native visibility toggle
		private var _persistence:PersistenceManager;
		private var _callCommand:FunctionCallCommand;
		private var _getCommand:FunctionCallCommand;
		private var _setCommand:FunctionCallCommand;
		private var _selectCommand:FunctionCallCommand;
		private var _quickSearchEnabled:Boolean = true;
		private var _repeatMessageMode:int = ConsoleMessageRepeatMode.STACK;
		private var _bgLayer:Sprite = new Sprite();
		private var _topLayer:Sprite = new Sprite();
		private var _consoleBackground:Sprite = new Sprite();
		private var _keystroke:uint = KeyBindings.ENTER;
		private var _modifier:uint = KeyBindings.CTRL_SHIFT;
		private var _lock:ConsoleLock = new ConsoleLock();
		private var _plugManager:PluginManager;
		private var _logManager:DLogManager;
		private var _autoCreateTagLogs:Boolean = true; //If true, automatically create new logs when a new tag is encountered
		private var _dockingGuides:DockingGuides;
		private var _overrideCallback:Function = null;
		private var _cancelNextKey:Boolean = false;
		private var _defaultInputCallback:Function;
		private var _mainConsoleView:ConsoleView;
		private var _debugDraw:DebugDraw;
		
		private var _consoleContainer:Sprite;
		private var _messaging:PimpCentral = new PimpCentral();
		
		private var _trigger:uint = Keyboard.TAB;
		
		private var _helpManager:HelpManager;
		
		private var _debugMode:Boolean = false; //Internal debugging flag
		
		static public const DOCK_TOP:int = 0;
		static public const DOCK_BOT:int = 1;
		static public const DOCK_WINDOWED:int = -1;
		
		static public var autoComplete:Boolean = true;
		
		//} end members
		//{ Instance
		/**
		 * Creates a new DConsole instance.
		 * This class is intended to always be on top of the stage of the application it is associated with.
		 * Using the DConsole.instance getter is recommended
		 */
		public function DConsole() {
			//Prepare logging
			_styleManager = new StyleManager(this);
			_persistence = new PersistenceManager(this);
			
			_logManager = new DLogManager(this);
			_mainConsoleView = new ConsoleView(this);
			
			_helpManager = new HelpManager(_messaging);
			
			output.currentLog = _logManager.currentLog;
			
			input.inputTextField.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			
			tabChildren = tabEnabled = false;
			
			_debugDraw = new DebugDraw(_messaging);
			
			_autoCompleteManager = new AutocompleteManager(input.inputTextField);
			_scopeManager = new ScopeManager(this, _autoCompleteManager);
			_autoCompleteManager.setDictionary(_globalDictionary);
			_referenceManager = new ReferenceManager(this, _scopeManager);
			_plugManager = new PluginManager(_scopeManager, _referenceManager, this, _topLayer, _bgLayer, _consoleBackground, _logManager);
			_commandManager = new CommandManager(this, _persistence, _referenceManager, _plugManager);
			_scopeManager.setCommandMgr(_commandManager);
			
			_consoleContainer = new Sprite();
			addChild(_consoleContainer);
			
			_consoleContainer.addChild(_debugDraw.shape);
			_consoleContainer.addChild(_bgLayer);
			_consoleContainer.addChild(_mainConsoleView);
			_consoleContainer.addChild(_topLayer);
			_dockingGuides = new DockingGuides();
			_consoleContainer.addChild(_dockingGuides);
			_toolTip = new ToolTip(this);
			_consoleContainer.addChild(_toolTip);
			
			input.addEventListener(Event.CHANGE, updateAssistantText);
			scaleHandle.addEventListener(Event.CHANGE, onScaleHandleDrag, false, 0, true);
			
			messaging.addCallback(Notifications.SCOPE_CHANGE_REQUEST, onScopeChangeRequest);
			messaging.addCallback(Notifications.EXECUTE_STATEMENT, onExecuteStatementNotification);
			messaging.addCallback(Notifications.CONSOLE_VIEW_TRANSITION_COMPLETE, onConsoleViewTransitionComplete);
			
			messaging.addCallback(Notifications.TOOLBAR_DRAG_START, onWindowDragStart);
			messaging.addCallback(Notifications.TOOLBAR_DRAG_STOP, onWindowDragStop);
			
			KeyboardManager.instance.addKeyboardShortcut(_keystroke, _modifier, toggleDisplay); //  [CTRL+SHIFT, ENTER]); //default keystroke
			
			_callCommand = new FunctionCallCommand("call", _scopeManager.callMethodOnScope, "Introspection", "Calls a method with args within the current introspection scope");
			_setCommand = new IntrospectionCommand("set", _scopeManager.setPropertyOnObject, "Introspection", "Sets a variable within the current introspection scope");
			_getCommand = new IntrospectionCommand("get", _scopeManager.getPropertyOnObject, "Introspection", "Prints a variable within the current introspection scope");
			_selectCommand = new IntrospectionCommand("select", select, "Introspection", "Selects the specified object or reference by identifier as the current introspection scope");
			
			var basicHelp:String = "";
			basicHelp += "\tKeyboard commands\n";
			basicHelp += "\t\tControl+Shift+Enter (default) -> Show/hide console\n";
			basicHelp += "\t\tMaster key (Default TAB) -> (When out of focus) Set the keyboard focus to the input field\n";
			basicHelp += "\t\tMaster key (Default TAB) -> (While caret is on an unknown term) Context sensitive search\n";
			basicHelp += "\t\tEnter -> Execute line\n";
			basicHelp += "\t\tPage up/Page down -> Vertical scroll by page\n";
			basicHelp += "\t\tArrow up -> Recall the previous executed line\n";
			basicHelp += "\t\tArrow down -> Recall the more recent executed line\n";
			basicHelp += "\t\tShift + Arrow keys -> Scroll\n";
			basicHelp += "\t\tMouse functions\n";
			basicHelp += "\t\tMousewheel -> Vertical scroll line by line\n";
			basicHelp += "\t\tClick drag below the input line -> Change console height\n";
			basicHelp += "\t\tClick drag console header -> Move the console window\n";
			basicHelp += "\tMisc\n";
			basicHelp += "\t\tUse the 'commands' command to list available commmands";
			
			_helpManager.addTopic("Basic instructions", basicHelp);
			
			print("Welcome to Doomsday Console II - www.doomsday.no", ConsoleMessageTypes.SYSTEM);
			print("Today is " + new Date().toString(), ConsoleMessageTypes.SYSTEM);
			print("Console version " + Version.Major + "." + Version.Minor, ConsoleMessageTypes.SYSTEM);
			print("Player version " + Capabilities.version, ConsoleMessageTypes.SYSTEM);
			
			setupDefaultCommands();
			setRepeatFilter(ConsoleMessageRepeatMode.STACK);
			
			visible = false;
			
			print("Ready. Type help to get started.", ConsoleMessageTypes.SYSTEM);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onWindowDragStop():void {
			beginFrameUpdates();
		}
		
		private function onWindowDragStart():void {
			stopFrameUpdates();
		}
		
		private function onConsoleViewTransitionComplete(md:MessageData):void {
			//md.data will be true if the console is now visible, or false if it's now hidden
			if (!md.data) {
				_consoleContainer.visible = false;
			}
		}
		
		public static function get debugDraw():DebugDraw {
			return console.debugDraw;
		}
		
		public static function getLogString():String {
			return console.getLogString();
		}
		
		private function onTextInput(e:TextEvent):void {
			//if (_cancelNextSpace && e.text==" ") {
			if (_cancelNextKey) {
				e.preventDefault();
			}
			_cancelNextKey = false;
		}
		
		public function get currentScope():IntrospectionScope {
			return _scopeManager.currentScope;
		}
		
		private function onExecuteStatementNotification(md:MessageData):void {
			executeStatement(String(md.data));
		}
		
		private function onScopeChangeRequest(md:MessageData):void {
			select(md.data);
		}
		
		private function stopFrameUpdates():void {
			removeEventListener(Event.ENTER_FRAME, frameUpdate);
		}
		
		private function beginFrameUpdates():void {
			addEventListener(Event.ENTER_FRAME, frameUpdate, false, -1000, false);
		}
		
		private function frameUpdate(e:Event = null):void {
			_plugManager.update();
			view.inspector.onFrameUpdate(e);
			messaging.send(Notifications.FRAME_UPDATE, null, this);
		}
		
		/**
		 * @readonly lock
		 */
		public function get lock():ConsoleLock {
			return _lock;
		}
		
		/**
		 * Change keyboard shortcut
		 */
		public function changeKeyboardShortcut(keystroke:uint, modifier:uint):void {
			KeyboardManager.instance.addKeyboardShortcut(keystroke, modifier, this.toggleDisplay, true);
		}
		
		private function setupDefaultCommands():void {
			//addCommand(new FunctionCallCommand("consoleHeight", setHeight, "View", "Change the number of lines to display. Example: setHeight 5"));
			createCommand("about", about, "System", "Credits etc");
			createCommand("clear", clear, "View", "Clear the console");
			
			createCommand("showTimestamps", output.toggleTimestamp, "View", "Toggle or set display of message timestamp");
			createCommand("showTags", toggleTags, "View", "Toggle or set the display of message tags");
			createCommand("showLineNumbers", output.toggleLineNumbers, "View", "Toggles or sets the display of line numbers");
			createCommand("setQuicksearch", toggleQuickSearch, "System", "Toggles or sets trigger key to search commands and methods for the current word");
			
			createCommand("help", getHelp, "System", "Output instructions. Append an argument to read more about that topic.");
			createCommand("clearhistory", _persistence.clearHistory, "System", "Clears the stored command history");
			createCommand("dock", setDockVerbose, "System", "Docks the console to either 'top'(default) 'bottom'/'bot' or 'window'");
			createCommand("maximizeConsole", maximize, "System", "Sets console height to fill the screen");
			createCommand("minimizeConsole", minimize, "System", "Sets console height to 1");
			createCommand("setRepeatFilter", setRepeatFilter, "System", "Sets the repeat message filter; 0 - Stack, 1 - Ignore, 2 - Passthrough");
			createCommand("repeat", repeatCommand, "System", "Repeats command string X Y times");
			addCommand(new FunctionCallCommand("resetConsole", resetConsole, "System", "Resets and clears the console"), false);
			
			if (Capabilities.isDebugger) {
				print("	Debugplayer commands added", ConsoleMessageTypes.SYSTEM);
				createCommand("gc", System.gc, "Debugplayer", "Forces a garbage collection cycle");
			}
			if (Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External") {
				print("	Projector commands added", ConsoleMessageTypes.SYSTEM);
				createCommand("quitapp", quitCommand, "Projector", "Quit the application");
			}
			createCommand("plugins", _plugManager.printPluginInfo, "Plugins", "Lists enabled plugin information");
			
			createCommand("commands", _commandManager.listCommands, "Utility", "Output a list of available commands. Add a second argument to search.");
			createCommand("search", searchCurrentLog, "Utility", "Searches the current log for a string and scrolls to the first matching line");
			createCommand("toClipboard", toClipBoard, "Utility", "Takes value X and puts it in the system clipboard (great for grabbing command XML output)");
			
			addCommand(_callCommand);
			addCommand(_getCommand);
			addCommand(_setCommand);
			addCommand(_selectCommand);
			
			createCommand("root", _scopeManager.selectBaseScope, "Introspection", "Selects the stage as the current introspection scope");
			createCommand("parent", _scopeManager.up, "Introspection", "(if the current scope is a display object) changes scope to the parent object");
			createCommand("children", _scopeManager.printChildren, "Introspection", "Get available children in the current scope");
			createCommand("variables", _scopeManager.printVariables, "Introspection", "Get available simple variables in the current scope");
			createCommand("complex", _scopeManager.printComplexObjects, "Introspection", "Get available complex variables in the current scope");
			createCommand("scopes", _scopeManager.printDownPath, "Introspection", "List available scopes in the current scope");
			createCommand("methods", _scopeManager.printMethods, "Introspection", "Get available methods in the current scope");
			createCommand("updateScope", _scopeManager.updateScope, "Introspection", "Gets changes to the current scope tree");
			
			createCommand("referenceThis", _referenceManager.getReference, "Referencing", "Stores a weak reference to the current scope in a specified id (referenceThis 1)");
			createCommand("getReference", _referenceManager.getReferenceByName, "Referencing", "Stores a weak reference to the specified scope in the specified id (getReference scopename 1)");
			createCommand("listReferences", _referenceManager.printReferences, "Referencing", "Lists all stored references and their IDs");
			createCommand("clearAllReferences", _referenceManager.clearReferences, "Referencing", "Clears all stored references");
			createCommand("clearReference", _referenceManager.clearReferenceByName, "Referencing", "Clears the specified reference");
			
			createCommand("loadTheme", _styleManager.load, "Theme", "Loads theme xml from urls; [x] theme [y] color table");
		
		}
		
		public function setMasterKey(key:uint):void {
			if (key == Keyboard.ENTER) {
				throw new Error("The master key can not be the enter key");
			}
			_trigger = key;
		}
		
		//private function switchMasterKey():void
		//{
		//_masterKeyMode = !_masterKeyMode;
		//if (_masterKeyMode) {
		//addSystemMessage("Current trigger is ctrl+space");
		//}else {
		//addSystemMessage("Current trigger is space, ctrl+space overrides");
		//}
		//}
		
		private function setDockVerbose(mode:String = "top"):void {
			mode = mode.toLowerCase();
			switch (mode) {
				case "bot":
				case "bottom":
					dock(DOCK_BOT);
					break;
				case "none":
				case "window":
					dock(DOCK_WINDOWED);
					break;
				case "top":
				default:
					dock(DOCK_TOP);
			}
		}
		
		private function get toolBar():ConsoleToolbar {
			return _mainConsoleView.toolbar;
		}
		
		private function get filterTabs():FilterTabRow {
			return _mainConsoleView.filtertabs;
		}
		
		private function get output():OutputField {
			return _mainConsoleView.output;
		}
		
		public function getLogString():String {
			return logs.rootLog.toString();
		}
		
		private function get scaleHandle():ScaleHandle {
			return _mainConsoleView.scaleHandle;
		}
		
		private function get assistant():Assistant {
			return _mainConsoleView.assistant;
		}
		
		private function get input():InputField {
			return _mainConsoleView.input;
		}
		
		private function selectTag(tag:String):void {
		
		}
		
		private function toggleTags(input:String = null):void {
			if (input == null) {
				view.output.showTag = !view.output.showTag;
			} else {
				view.output.showTag = StringUtil.verboseToBoolean(input);
			}
			view.output.update();
		}
		
		private function resetConsole():void {
			persistence.clearAll();
			view.splitRatio = persistence.verticalSplitRatio.value;
			onStageResize();
			_logManager.currentLog.clear();
			_logManager.clearFilters();
			addSystemMessage("GUI and history reset");
		}
		
		private function about():void {
			addSystemMessage("Doomsday Console II");
			addSystemMessage("\t\tversion " + Version.Major + "." + Version.Minor);
			addSystemMessage("\t\thttp://doomsdayconsole.googlecode.com");
			addSystemMessage("\t\tconcept and development by www.doomsday.no & www.furusystems.com");
		}
		
		private function addSearch(term:String):void {
			_logManager.addFilter(new DLogFilter(term));
		}
		
		public function searchCurrentLog(term:String):void {
			var idx:int = _logManager.searchCurrentLog(term);
			if (idx > -1) {
				output.scrollToLine(idx);
					//print("'" + term + "' found in log "+_logManager.currentLog+" at line " + idx);
			} else {
				addErrorMessage("Not found");
			}
		}
		
		public function get currentLog():DConsoleLog {
			return _logManager.currentLog;
		}
		
		private function toClipBoard(str:String):void {
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, str);
		}
		
		private function getLoader(url:String):Loader {
			var l:Loader = new Loader();
			l.load(new URLRequest(url));
			return l;
		}
		
		private function repeatCommand(cmd:String, count:int = 1):void {
			for (var i:int = 0; i < count; i++) {
				executeStatement(cmd);
			}
		}
		
		public function select(target:*):void {
			if (_scopeManager.currentScope == target)
				return;
			try {
				_scopeManager.setScopeByName(String(target));
			} catch (e:Error) {
				try {
					_referenceManager.setScopeByReferenceKey(target);
				} catch (e:Error) {
					try {
						if (typeof target == "string") {
							throw new Error();
						}
						_scopeManager.setScope(target);
					} catch (e:Error) {
						print("No such scope", ConsoleMessageTypes.ERROR);
					}
				}
			}
		}
		
		private function toggleQuickSearch(input:String = null):void {
			if (input == null) {
				setQuickSearch(!_quickSearchEnabled);
			} else {
				setQuickSearch(StringUtil.verboseToBoolean(input));
			}
		}
		
		private function onScaleHandleDrag(e:Event):void
		
		{
			var my:Number;
			var eh:Number = 14;
		}
		
		private function quitCommand(code:int = 0):void {
			System.exit(code);
		}
		
		private function getHelp(topic:String = ""):void {
			if (topic == "") {
				addSystemMessage(_helpManager.getTopic("Basic instructions"));
				addSystemMessage(_helpManager.getToc());
			} else {
				addSystemMessage(_helpManager.getTopic(topic));
			}
		}
		
		public function executeStatement(statement:String, echo:Boolean = false):* {
			if (echo)
				print(statement, ConsoleMessageTypes.USER);
			return _commandManager.tryCommand(statement);
		}
		
		private function updateAssistantText(e:Event = null):void {
			if (_overrideCallback != null)
				return;
			var cmd:ConsoleCommand;
			var helpText:String;
			try {
				cmd = _commandManager.parseForCommand(input.text);
				helpText = cmd.helpText;
			} catch (e:Error) {
				helpText = "";
			}
			var secondElement:String = TextUtils.parseForSecondElement(input.text);
			if (secondElement) {
				if (cmd == _callCommand) {
					try {
						helpText = InspectionUtils.getMethodTooltip(_scopeManager.currentScope.targetObject, secondElement);
					} catch (e:Error) {
						helpText = cmd.helpText;
					}
				} else if (cmd == _setCommand || cmd == _getCommand) {
					try {
						helpText = InspectionUtils.getAccessorTooltip(_scopeManager.currentScope.targetObject, secondElement);
					} catch (e:Error) {
						helpText = cmd.helpText;
					}
				}
			}
			if (helpText != "") {
				assistant.text = "?	" + cmd.trigger + ": " + helpText;
			} else {
				assistant.clear();
			}
		}
		
		public function setScope(o:Object):void {
			_scopeManager.setScope(o);
		}
		
		public function createCommand(triggerPhrase:String, func:Function, commandGroup:String = "Application", helpText:String = ""):void {
			addCommand(new FunctionCallCommand(triggerPhrase, func, commandGroup, helpText));
		}
		
		/**
		 * Add a custom command to the console
		 * @param	command
		 * An instance of FunctionCallCommand or ConsoleEventCommand
		 */
		public function addCommand(command:ConsoleCommand, includeInHistory:Boolean = true):void {
			try {
				_commandManager.addCommand(command, includeInHistory);
				_globalDictionary.addToDictionary(command.trigger);
			} catch (e:ArgumentError) {
				print(e.message, ConsoleMessageTypes.ERROR);
			}
		}
		
		public function removeCommand(trigger:String):void {
			_commandManager.removeCommand(trigger);
		}
		
		/**
		 * A generic function to add as listener to events you want logged
		 * @param	e
		 */
		public function onEvent(e:Event):void {
			print("Event: " + e.toString(), ConsoleMessageTypes.INFO);
		}
		
		private function createMessages(str:String, type:String, tag:String):Vector.<ConsoleMessage> {
			var out:Vector.<ConsoleMessage> = new Vector.<ConsoleMessage>();
			var split:Array = str.split("\n").join("\r").split("\r");
			if (split.join("").length < 1 && ignoreBlankLines)
				return out;
			var date:String = String(new Date().getTime());
			var msg:ConsoleMessage;
			for (var i:int = 0; i < split.length; i++) {
				var txt:String = split[i];
				if (txt.length < 1 && ignoreBlankLines)
					continue;
				if (txt.indexOf("com.furusystems.dconsole2") > -1 || txt.indexOf("adobe.com/AS3") > -1)
					continue;
				msg = new ConsoleMessage(txt, date, type, tag);
				out.push(msg);
			}
			return out;
		}
		
		public function createTypeFilter(type:String):void {
			_logManager.addFilter(new DLogFilter("", type));
		}
		
		public function createSearchFilter(term:String):void {
			_logManager.addFilter(new DLogFilter(term));
		}
		
		public function printTo(targetLog:String, str:String, type:String = ConsoleMessageTypes.INFO, tag:String = ""):void {
			var log:DConsoleLog = _logManager.getLog(targetLog);
			var messages:Vector.<ConsoleMessage> = createMessages(str, type, tag);
		}
		
		/**
		 * Add a message to the current console tab
		 * @param	str
		 * The string to be added. A timestamp is automaticaly prefixed
		 */
		public function print(str:String, type:String = ConsoleMessageTypes.INFO, tag:String = TAG):void {
			//TODO: Per message, examine filters and append relevant messages to the relevant logs
			var _tagLog:DConsoleLog;
			if (tag != TAG && _autoCreateTagLogs) {
				_tagLog = _logManager.getLog(tag);
			}
			var _rootLog:DConsoleLog = _logManager.rootLog;
			var messages:Vector.<ConsoleMessage> = createMessages(str, type, tag);
			var msg:ConsoleMessage;
			for (var i:int = 0; i < messages.length; i++) {
				//break;
				msg = messages[i];
				if (_rootLog.prevMessage) {
					if (_rootLog.prevMessage.text == msg.text && _rootLog.prevMessage.tag == msg.tag && _rootLog.prevMessage.type == msg.type) {
						switch (_repeatMessageMode) {
							case ConsoleMessageRepeatMode.STACK:
								_rootLog.prevMessage.repeatcount++;
								_rootLog.prevMessage.timestamp = msg.timestamp;
								_rootLog.setDirty();
								if (_tagLog) {
									_tagLog.setDirty();
								}
								continue;
								break;
							case ConsoleMessageRepeatMode.IGNORE:
								continue;
								break;
						}
					}
				}
				if (msg.type != ConsoleMessageTypes.USER) {
					var evt:Message;
					if (msg.type == ConsoleMessageTypes.ERROR) {
						evt = Notifications.ERROR;
					} else {
						evt = Notifications.NEW_CONSOLE_OUTPUT;
					}
					messaging.send(evt, msg, this);
				}
				_rootLog.addMessage(msg);
				if (_tagLog)
					_tagLog.addMessage(msg);
			}
			output.update();
		}
		
		/**
		 * Clear the console
		 */
		public function clear():void {
			_logManager.currentLog.clear();
			output.drawMessages();
		}
		
		private function setupStageAlignAndScale():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			print("StageAlign set to TOP_LEFT, StageScaleMode set to NO_SCALE", ConsoleMessageTypes.SYSTEM);
		}
		
		private function onAddedToStage(e:Event):void {
			//branching for air
			is_air = Capabilities.playerType == "Desktop";
			
			Logging.logBinding = new ConsoleLogBinding();
			KeyboardManager.instance.setup(stage);
			if (stage.align != StageAlign.TOP_LEFT) {
				print("Warning: stage.align is not set to TOP_LEFT; This might cause scaling issues", ConsoleMessageTypes.ERROR);
				print("Fix: stage.align = StageAlign.TOP_LEFT;", ConsoleMessageTypes.DEBUG);
			}
			if (stage.scaleMode != StageScaleMode.NO_SCALE) {
				print("Warning: stage.scaleMode is not set to NO_SCALE; This might cause scaling issues", ConsoleMessageTypes.ERROR);
				print("Fix: stage.scaleMode = StageScaleMode.NO_SCALE;", ConsoleMessageTypes.DEBUG);
			}
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, int.MAX_VALUE);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, int.MAX_VALUE);
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_scopeManager.selectBaseScope();
			
			view.setHeaderText("Doomsday Console " + Version.Major + "." + Version.Minor);
			
			onStageResize(e);
		}
		
		private function onStageResize(e:Event = null):void {
			_mainConsoleView.consolidateView();
			_dockingGuides.resize();
		}
		
		public function stackTrace():void {
			var e:Error = new Error();
			var s:String = e.getStackTrace();
			var split:Array = s.split("\n");
			split.shift();
			s = "Stack trace: \n\t" + split.join("\n\t");
			print(s, ConsoleMessageTypes.INFO);
		}
		
		private function doSearch(searchString:String, includeAccessors:Boolean = false, includeCommands:Boolean = true, includeScopeMethods:Boolean = false):Vector.<String> {
			var outResult:Vector.<String> = new Vector.<String>();
			if (searchString.length < 1)
				return outResult;
			var found:Boolean = false;
			var result:Vector.<String>;
			var maxrow:int = 4;
			if (includeScopeMethods) {
				result = _scopeManager.doSearch(searchString, ScopeManager.SEARCH_METHODS);
				outResult = outResult.concat(result);
				var out:String = "";
				var count:int = 0;
				if (result.length > 0) {
					print("Scope methods matching '" + searchString + "'", ConsoleMessageTypes.SYSTEM);
					for (var i:int = 0; i < result.length; i++) {
						out += result[i] + " ";
						count++;
						if (count > maxrow) {
							count = 0;
							print(out, ConsoleMessageTypes.INFO);
							out = "";
						}
					}
					if (out != "")
						print(out, ConsoleMessageTypes.INFO);
					found = true;
				}
			}
			if (includeCommands) {
				result = _commandManager.doSearch(searchString);
				outResult = outResult.concat(result);
				count = 0;
				out = "";
				if (result.length > 0) {
					print("Commands matching '" + searchString + "'", ConsoleMessageTypes.SYSTEM);
					for (i = 0; i < result.length; i++) {
						out += "\t" + result[i] + " ";
						count++;
						if (count > maxrow) {
							count = 0;
							print(out, ConsoleMessageTypes.INFO);
							out = "";
						}
					}
					if (out != "")
						print(out, ConsoleMessageTypes.INFO);
					found = true;
				}
			}
			if (includeAccessors) {
				result = _scopeManager.doSearch(searchString, ScopeManager.SEARCH_ACCESSORS);
				outResult = outResult.concat(result);
				count = 0;
				out = "";
				if (result.length > 0) {
					print("Scope accessors matching '" + searchString + "'", ConsoleMessageTypes.SYSTEM);
					for (i = 0; i < result.length; i++) {
						out += result[i] + " ";
						count++;
						if (count > maxrow) {
							count = 0;
							print(out, ConsoleMessageTypes.INFO);
							out = "";
						}
					}
					if (out != "")
						print(out, ConsoleMessageTypes.INFO);
					found = true;
				}
			}
			result = _scopeManager.doSearch(searchString, ScopeManager.SEARCH_CHILDREN);
			outResult = outResult.concat(result);
			count = 0;
			out = "";
			if (result.length > 0) {
				print("Children matching '" + searchString + "'", ConsoleMessageTypes.SYSTEM);
				for (i = 0; i < result.length; i++) {
					out += result[i] + " ";
					count++;
					if (count > maxrow) {
						count = 0;
						print(out, ConsoleMessageTypes.INFO);
						out = "";
					}
				}
				if (out != "")
					print(out, ConsoleMessageTypes.INFO);
				found = true;
			}
			//if (!found) {
			//TODO: Do we really need this junk feedback?
			//print("No matches for '" + searchString + "'",ConsoleMessageTypes.ERROR);
			//}
			return outResult;
		
		}
		
		private function get currentMessageLogVector():Vector.<ConsoleMessage> {
			return _logManager.currentLog.messages;
		}
		
		public static function refresh():void {
			console.refresh();
		}
		
		public function show():void {
			if (!stage)
				return;
			if (!visible)
				toggleDisplay();
		}
		
		public function hide():void {
			if (!stage)
				return;
			if (visible)
				toggleDisplay();
		}
		
		override public function get visible():Boolean {
			return _visible;
		}
		
		override public function set visible(value:Boolean):void {
			_visible = value;
			if (_visible) {
				_consoleContainer.visible = true;
				view.show();
			} else
				view.hide();
		}
		
		public function set isVisible(b:Boolean):void {
			_isVisible = b;
			super.visible = _isVisible;
		}
		
		public function get isVisible():Boolean {
			return _isVisible;
		}
		
		public function toggleDisplay():void {
			// Return if locked
			if (lock.locked) {
				return;
			}
			
			visible = !visible;
			var i:int;
			var bounds:Rectangle = _persistence.rect;
			if (visible) {
				if (!_initialized) {
					initialize();
				}
				if (parent) {
					parent.addChild(this);
				}
				tabOrderOff();
				input.focus();
				input.text = "";
				updateAssistantText();
				beginFrameUpdates();
				messaging.send(Notifications.CONSOLE_SHOW, null, this);
			} else {
				tabOrderOn();
				stopFrameUpdates();
				messaging.send(Notifications.CONSOLE_HIDE, null, this);
			}
		}
		
		private function tabOrderOn():void {
			if (parent) {
				parent.tabChildren = parent.tabEnabled = _prevTabSettings;
			}
		}
		
		private function tabOrderOff():void {
			if (parent) {
				_prevTabSettings = parent.tabChildren;
				parent.tabChildren = parent.tabEnabled = false;
			}
		}
		
		private function initialize():void {
			_initialized = true;
			if (!_styleManager.themeLoaded) {
				_styleManager.load();
			}
			_mainConsoleView.consolidateView();
		}
		
		override public function get height():Number {
			return _mainConsoleView.height;
		}
		
		override public function set height(value:Number):void {
			_mainConsoleView.height = value;
		}
		
		override public function get width():Number {
			return _mainConsoleView.rect.width;
		}
		
		override public function set width(value:Number):void {
			_mainConsoleView.width = value;
		}
		
		public function setQuickSearch(newvalue:Boolean = true):void {
			_quickSearchEnabled = newvalue;
			print("Quick-searching: " + _quickSearchEnabled, ConsoleMessageTypes.SYSTEM);
		}
		
		//minmaxing size
		public function maximize():void {
			if (!stage)
				return;
			_mainConsoleView.maximize();
		}
		
		public function minimize():void {
			_mainConsoleView.minimize();
		}
		
		//keyboard event handlers
		
		private function onKeyUp(e:KeyboardEvent):void {
			KeyboardManager.instance.handleKeyUp(e);
			if (visible) {
				var cmd:String = "";
				var _testCmd:Boolean = false;
				if (e.keyCode == Keyboard.UP) {
					if (!e.shiftKey) {
						cmd = _persistence.historyUp();
						_testCmd = true;
					} else {
						return;
					}
					
				} else if (e.keyCode == Keyboard.DOWN) {
					if (!e.shiftKey) {
						cmd = _persistence.historyDown();
						_testCmd = true;
					} else {
						return;
					}
				}
				if (_testCmd) {
					input.text = cmd;
					input.focus();
					var spaceIndex:int = input.text.indexOf(" ");
					
					if (spaceIndex > -1) {
						input.inputTextField.setSelection(input.text.indexOf(" ") + 1, input.text.length);
					} else {
						input.inputTextField.setSelection(0, input.text.length);
					}
					updateAssistantText();
				}
			}
		}
		
		private function keyHandler(e:KeyboardEvent):KeyHandlerResult {
			var out:KeyHandlerResult = keyhandlerResult;
			out.reset();
			var triggered:Boolean = e.keyCode == _trigger;
			if (stage.focus == input.inputTextField) {
				if (!e.shiftKey && triggered) {
					out.swallowEvent = true;
					out.autoCompleted = doComplete();
					if (out.autoCompleted) {
						if (shouldCancel(e.keyCode)) {
							cancelKey(e);
						}
					}
					return out;
				}
			} else {
				if (triggered) {
					input.focus();
					out.swallowEvent = true;
					return out;
				}
			}
			if (e.keyCode == Keyboard.ESCAPE) {
				if (_overrideCallback != null) {
					clearOverrideCallback();
				}
				messaging.send(Notifications.ESCAPE_KEY, null, this);
				out.swallowEvent = true;
				return out;
			}
			if (e.shiftKey) {
				switch (e.keyCode) {
					case Keyboard.UP:
						output.scroll(1);
						out.swallowEvent = true;
						return out;
					case Keyboard.DOWN:
						output.scroll(-1);
						out.swallowEvent = true;
						return out;
					case Keyboard.LEFT:
						//TODO: previous tab
						break;
					case Keyboard.RIGHT:
						//TODO: next tab
						break;
				}
			}
			if (e.keyCode == Keyboard.ENTER && stage.focus == input.inputTextField) {
				out.swallowEvent = true;
				if (input.text.length < 1) {
					//input.focus();
					return out;
				}
				var success:Boolean = false;
				var passToDefault:Boolean = false;
				var errorMessage:String = "";
				print(input.text, ConsoleMessageTypes.USER);
				if (_overrideCallback != null) {
					_overrideCallback(input.text);
					success = true;
				} else {
					try {
						var attempt:* = executeStatement(input.text);
						success = true;
					} catch (error:ConsoleAuthError) {
						//TODO: This needs a more graceful solution. Dual auth error prints = lame
					} catch (error:ArgumentError) {
						switch (error.message) {
							case ErrorStrings.STRING_PARSE_ERROR_TERMINATION:
								passToDefault = true;
								break;
						}
						errorMessage = error.message;
					} catch (error:CommandError) {
						passToDefault = true;
						errorMessage = error.message;
					} catch (error:Error) {
						print(error.message, ConsoleMessageTypes.ERROR);
					}
				}
				if (passToDefault && _defaultInputCallback != null) {
					var ret:* = _defaultInputCallback(input.text);
					if (ret) {
						print(ret, ConsoleMessageTypes.INFO);
					}
				} else {
					print(errorMessage, ConsoleMessageTypes.ERROR);
				}
				output.scrollToBottom();
				input.clear();
				updateAssistantText();
				out.swallowEvent = true;
			} else if (e.keyCode == Keyboard.PAGE_DOWN) {
				output.scroll(-output.numLines);
				out.swallowEvent = true;
			} else if (e.keyCode == Keyboard.PAGE_UP) {
				output.scroll(output.numLines);
				out.swallowEvent = true;
			} else if (e.keyCode == Keyboard.HOME) {
				output.scrollIndex = 0;
				out.swallowEvent = true;
			} else if (e.keyCode == Keyboard.END) {
				output.scrollIndex = output.maxScroll;
				out.swallowEvent = true;
			} else if (e.keyCode == Keyboard.SPACE) {
				out.swallowEvent = true;
			}
			return out;
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			KeyboardManager.instance.handleKeyDown(e);
			if (!visible)
				return; //Ignore if invisible
			if (e.keyCode == Keyboard.TAB)
				stage.focus = input.inputTextField; //why?
			var result:KeyHandlerResult = keyHandler(e);
			if (result.swallowEvent) {
				if (is_air) {
					if (!result.autoCompleted) {
						if (e.keyCode == Keyboard.SPACE) {
							view.input.insertAtCaret(" ");
						}
					} else {
						input.moveCaretToEnd();
					}
				}
				
				e.stopImmediatePropagation();
				e.stopPropagation();
				e.preventDefault();
			}
		}
		
		private function shouldCancel(keyCode:uint):Boolean {
			return keyCode >= 13 || keyCode == Keyboard.SPACE;
		}
		
		private function cancelKey(e:KeyboardEvent):void {
			if (is_air)
				return;
			_cancelNextKey = true;
			e.stopPropagation();
		}
		
		/**
		 * Sets the handling method for repeated messages with identical values
		 * @param	filter
		 * One of the 3 modes described in the no.doomsday.console.core.output.MessageRepeatMode enum
		 */
		public function setRepeatFilter(filter:int):void {
			switch (filter) {
				case ConsoleMessageRepeatMode.IGNORE:
					print("Repeat mode: Repeated messages are now ignored", ConsoleMessageTypes.SYSTEM);
					break;
				case ConsoleMessageRepeatMode.ALLOW:
					print("Repeat mode: Repeated messages are now allowed", ConsoleMessageTypes.SYSTEM);
					break;
				case ConsoleMessageRepeatMode.STACK:
					print("Repeat mode: Repeated messages are now stacked", ConsoleMessageTypes.SYSTEM);
					break;
				default:
					throw new Error("Unknown filter type");
			}
			_repeatMessageMode = filter;
		}
		
		private function doComplete():Boolean {
			if (!DConsole.autoComplete) return false;
			var flag:Boolean = false;
			
			if (input.text.length < 1 || _overrideCallback != null)
				return false;
			
			var word:String = input.wordAtCaret;
			
			var isFirstWord:Boolean = input.text.lastIndexOf(word) < 1;
			var firstWord:String;
			if (isFirstWord) {
				firstWord = word;
			} else {
				firstWord = input.firstWord;
			}
			var wordKnown:Boolean;
			wordKnown = _autoCompleteManager.isKnown(word, !isFirstWord, isFirstWord);
			if (wordKnown || !isNaN(Number(word))) {
				//this word is okay, so accept the completion
				var wordIndex:int = input.firstIndexOfWordAtCaret;
				//is there currently a selection?
				if (input.inputTextField.selectedText.length > 0) {
					input.moveCaretToIndex(input.selectionBeginIndex);
					wordIndex = input.selectionBeginIndex;
				} else if (input.text.charAt(input.caretIndex) == " " && input.caretIndex != input.text.length - 1) {
					//input.moveCaretToIndex(input.caretIndex - 1);
				}
				
				word = input.wordAtCaret;
				wordIndex = input.caretIndex;
				
				//case correction
				var temp:String = input.text;
				try {
					temp = temp.replace(word, _autoCompleteManager.correctCase(word));
					input.text = temp;
				} catch (e:Error) {
				}
				
				//is there a word after the current word?
				if (wordIndex + word.length < input.text.length - 1) {
					input.moveCaretToIndex(wordIndex + word.length);
					input.selectWordAtCaret();
				} else {
					//if it's the last word
					if (input.text.charAt(input.text.length - 1) != " ") {
						input.inputTextField.appendText(" ");
					}
					input.moveCaretToEnd();
				}
				return true;
			} else {
				if (_quickSearchEnabled) {
					var getSet:Boolean = (firstWord == _getCommand.trigger || firstWord == _setCommand.trigger);
					var call:Boolean = (firstWord == _callCommand.trigger);
					var select:Boolean = (firstWord == _selectCommand.trigger);
					var searchResult:Vector.<String> = doSearch(word, !isFirstWord || select, isFirstWord, call);
					if (searchResult.length == 1) {
						if (searchResult[0].indexOf(word) == 0) {
							input.selectWordAtCaret();
							input.inputTextField.replaceSelectedText(searchResult[0] + " ");
							input.moveCaretToIndex(wordIndex + searchResult[0].length + 1);
							return true;
						}
					} else if (searchResult.length > 1) {
						input.moveCaretToEnd();
						return true;
					}
				}
				if (flag) {
					input.selectWordAtCaret();
				} else {
					//input.moveCaretToIndex(input.firstIndexOfWordAtCaret + input.wordAtCaret.length);
				}
				return false;
			}
		}
		
		public function get view():ConsoleView {
			return _mainConsoleView;
		}
		
		public function get logs():DLogManager {
			return _logManager;
		}
		
		public function get defaultInputCallback():Function {
			return _defaultInputCallback;
		}
		
		public function set defaultInputCallback(value:Function):void {
			if (value == null) {
				_defaultInputCallback = null;
				return;
			}
			if (value.length != 1)
				throw new Error("Default input callback must take exactly one argument");
			_defaultInputCallback = value;
		}
		
		public function lockOutput():void {
			output.lockOutput();
		}
		
		public function unlockOutput():void {
			output.unlockOutput();
		}
		
		public function loadStyle(themeURI:String = null, colorsURI:String = null):void {
			_styleManager.load(themeURI, colorsURI);
		}
		
		public function get scopeManager():ScopeManager {
			return _scopeManager;
		}
		
		public function get persistence():PersistenceManager {
			return _persistence;
		}
		
		public function get pluginManager():PluginManager {
			return _plugManager;
		}
		
		public function setHeaderText(title:String):void {
			_mainConsoleView.toolbar.setTitle(title);
		}
		
		public function setOverrideCallback(callback:Function):void {
			addSystemMessage("Override callback active, hit ESC to resume normal ops");
			_overrideCallback = callback;
		}
		
		public function clearOverrideCallback():void {
			addSystemMessage("Override callback cleared");
			_overrideCallback = null;
		}
		//}
		
		//{ Statics
		
		/**
		 * If true, the console instance cannot be selected by the console. The default is true, which is recommended.
		 */
		public static var CONSOLE_SAFE_MODE:Boolean = true;
		/**
		 * If true, the stage can't be selected by the console. The default is true, because Stage properties behave strangely when rapidly messed with.
		 * Need to examine this further.
		 */
		public static var STAGE_SAFE_MODE:Boolean = true;
		
		public static function stackTrace():void {
			console.stackTrace();
		}
		
		/**
		 * Removes the default input callback
		 * @see setDefaultInputCallback
		 */
		public static function clearDefaultInputCallback():void {
			console.defaultInputCallback = null;
		}
		
		/**
		 * Declares a default input callback
		 * This callback will receive any input the console doesn't understand
		 * @param	callback
		 */
		public static function setDefaultInputCallback(callback:Function):void {
			if (callback.length != 1)
				throw new Error("The default input callback must accept exactly 1 string argument");
			console.defaultInputCallback = callback;
		}
		
		private static var _instance:DConsole;
		private static var keyboardShortcut:Array = [];
		private var _prevTabSettings:Boolean = false;
		private var is_air:Boolean;
		private var keyhandlerResult:KeyHandlerResult = new KeyHandlerResult(); //reuse same instance YESSss
		
		/**
		 * The internal tag used as the defalt for logging
		 */
		public static const TAG:String = "DConsole";
		
		public static function get ignoreBlankLines():Boolean {
			return DConsole(console).ignoreBlankLines;
		}
		
		public static function set ignoreBlankLines(b:Boolean):void {
			DConsole(console).ignoreBlankLines = b;
		}
		
		/**
		 * Returns the object currently selected as the console scope
		 * @return An object
		 * @see select
		 */
		public static function getCurrentTarget():Object {
			return (console as DConsole).scopeManager.currentScope.targetObject;
		}
		
		/**
		 * Get the singleton IConsole instance
		 */
		public static function get console():IConsole {
			if (!_instance) {
				_instance = new DConsole();
				if (keyboardShortcut.length > 0) {
					console.changeKeyboardShortcut(keyboardShortcut[0], keyboardShortcut[1]);
				}
			}
			return _instance;
		}
		
		/**
		 * Sets the console title bar text
		 * @param	title
		 */
		public static function setTitle(title:String):void {
			console.setHeaderText(title);
		}
		
		/**
		 * Get the singleton console view display object
		 */
		public static function get view():DisplayObject {
			return console as DisplayObject;
		}
		
		/**
		 * Adds a message
		 * @param	msg
		 * The text to output
		 * @param	type
		 * The message type, one of the options available in ConsoleMessageTypes
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function print(msg:String, type:String = ConsoleMessageTypes.INFO, tag:String = TAG):void {
			console.print(msg, type, tag);
		}
		
		/**
		 * Add a message with system color coding
		 * @param	msg
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function addSystemMessage(msg:String, tag:String = TAG):void {
			console.print(msg, ConsoleMessageTypes.SYSTEM, tag);
		}
		
		/**
		 * Add a message with warning color coding
		 * @param	msg
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function addWarningMessage(msg:String, tag:String = TAG):void {
			console.print(msg, ConsoleMessageTypes.WARNING, tag);
		}
		
		/**
		 * Add a message with error color coding
		 * @param	msg
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function addErrorMessage(msg:String, tag:String = TAG):void {
			console.print(msg, ConsoleMessageTypes.ERROR, tag);
		}
		
		/**
		 * Add a message with ridiculous random color coding.
		 * For the love of god and all that is holy, use sparingly if at all!
		 * @param	msg
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function addHoorayMessage(msg:String, tag:String = TAG):void {
			console.print(msg, ConsoleMessageTypes.HOORAY, tag);
		}
		
		/**
		 * Add a message with fatal error color coding (incredibly vile)
		 * @param	msg
		 * @param	tag
		 * The string tag for identifying the source or topic of this message
		 */
		public static function addFatalMessage(msg:String, tag:String = TAG):void {
			console.print(msg, ConsoleMessageTypes.FATAL, tag)
		}
		
		/**
		 * Create a command for calling a specific function
		 * @param	triggerPhrase
		 * The trigger word for the command
		 * @param	func
		 * The function to call
		 * @param	category
		 * Optional: The group name you want the command sorted under
		 * @param	helpText
		 * Optional: Any text you want displayed in the assistant when this command is being typed
		 */
		public static function createCommand(triggerPhrase:String, func:Function, category:String = "Application", helpText:String = ""):void {
			console.createCommand(triggerPhrase, func, category, helpText);
		}
		
		/**
		 * Removes a command keyed by its trigger phrase
		 * @param	triggerPhrase
		 */
		public static function removeCommand(triggerPhrase:String):void {
			console.removeCommand(triggerPhrase);
		}
		
		/**
		 * Use this to print event messages on dispatch
		 * (addEventListener(Event.CHANGE, ConsoleUtil.onEvent))
		 */
		public static function get onEvent():Function {
			return console.onEvent;
		}
		
		/**
		 * Clear the console log(s)
		 */
		public static function get clear():Function {
			return console.clear;
		}
		
		public function get debugDraw():DebugDraw {
			return _debugDraw;
		}
		
		/**
		 * Registers plugins and plugin bundles by their class types
		 * A plugin is an implementor of any interface deriving from IDConsolePlugin
		 * A plugin bundle is an implementor of IPluginBundle
		 * @param	...args
		 * @example
		 * The following code shows the BasicPlugins bundle being registered, alongside the JSRouterUtil plugin
		 * <listing>
		 * DConsole.registerPlugins(AllPlugins,JSRouterUtil);
		 * </listing>
		 */
		public static function registerPlugins(... args:Array):void {
			for (var i:int = 0; i < args.length; i++) {
				(console as DConsole).pluginManager.registerPlugin(args[i]);
			}
		}
		
		/**
		 * Sets the specified object as the console's current scope
		 * @param	object
		 * @see getCurrentTarget
		 */
		public static function select(object:Object):void {
			console.select(object);
		}
		
		/**
		 * Show the console
		 * @see hide
		 */
		public static function show():void {
			console.show();
		}
		
		/**
		 * Hide the console
		 * @see show
		 */
		public static function hide():void {
			console.hide();
		}
		
		/**
		 * Execute a console command statement
		 * @param	statement
		 * The statement, eg. "setFrameRate 60" etc
		 * @param	echo
		 * Wether to echo this statement in the console (default false)
		 * @return
		 * The return value of the executed statement, if any.
		 */
		public static function executeStatement(statement:String, echo:Boolean = false):* {
			return console.executeStatement(statement, echo);
		}
		
		/**
		 * Set keyboard shortcut
		 *
		 * @param keystroke	The keystroke
		 * @param modifier	The modifier
		 */
		public static function setKeyboardShortcut(key:uint, modifier:uint):Boolean {
			var success:Boolean = false;
			/*
			 * If is a valid keyboard shortcut
			 *
			 * 1. If the console is not initialized store for later, and modify after creation.
			 * 2. If the console is initialized call instance.changeKeyboardShortcut
			 */
			if (KeyboardManager.instance.validateKeyboardShortcut(key, modifier)) {
				if (!_instance) {
					keyboardShortcut = [key, modifier];
				} else {
					console.changeKeyboardShortcut(key, modifier);
				}
				success = true;
			}
			return success;
		}
		
		/**
		 * Change keyboard shortcut.
		 *
		 * @param keystroke	The key
		 * @param modifier	The modifier
		 */
		private static function changeKeyboardShortcut(key:uint, modifier:uint):void {
			console.changeKeyboardShortcut(key, modifier);
		}
		
		/**
		 * Declares an overriding callback for all console input
		 * While active, regular console input behavior will cease, and all text input will be passed to the specified callback
		 * @param	callback
		 */
		static public function setOverrideCallback(callback:Function):void {
			console.setOverrideCallback(callback);
		}
		
		/**
		 * Removes the overriding callback set in setOverrideCallback
		 * @see setOverrideCallback
		 */
		static public function clearOverrideCallback():void {
			console.clearOverrideCallback();
		}
		
		/**
		 * Resets all persistent data (command history, console position, docking etc)
		 */
		static public function clearPersistentData():void {
			DConsole(console).persistence.clearAll();
		}
		
		/**
		 * Set the console's docking state
		 * @param	mode one of the DOCK_* static constants on DConsole
		 */
		public static function dock(mode:int):void {
			console.view.dockingMode = mode;
		}
		
		public function setTheme(colors:XML, theme:XML):void {
			_styleManager.setThemeXML(colors, theme);
		}
		
		public function getTheme():Array {
			return [_styleManager.colorXML, _styleManager.themeXML];
		}
		
		/**
		 * Lock
		 *
		 * @param secret The secret to lock the console with.
		 */
		public static function setMagicWord(secret:String):void {
			DConsole(console)._lock.lockWithKeycodes(KeyBindings.toCharCodes(secret), DConsole(console).toggleDisplay);
		}
		
		/**
		 * Lock with keyCodes
		 *
		 * @param keyCodes The keyCodes to lock the console with.
		 */
		public static function setMagicSequence(keyCodes:Array):void {
			DConsole(console)._lock.lockWithKeycodes(keyCodes, DConsole(console).toggleDisplay);
		}
		
		public static function setMasterKey(key:uint):void {
			DConsole(console).setMasterKey(key);
		}
		
		/* INTERFACE com.furusystems.dconsole2.IConsole */
		
		public function refresh():void {
			scopeManager.updateScope();
		}
		
		public function getPluginInstance(type:Class):IDConsolePlugin 
		{
			return pluginManager.getPluginByType(type);
		}
		
		public function get messaging():PimpCentral {
			return _messaging;
		}
	}

}
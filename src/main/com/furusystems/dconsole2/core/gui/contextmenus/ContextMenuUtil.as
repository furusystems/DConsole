package com.furusystems.dconsole2.core.gui.contextmenus {
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.references.ReferenceManager;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.plugins.controller.ControllerUtil;
	import com.furusystems.dconsole2.plugins.measurebracket.MeasurementBracketUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * Utility for binding flash player context menus to console ops
	 * @author Andreas Roenning
	 */
	
	//TODO: Implement as plugin
	public class ContextMenuUtil {
		private static var console:DConsole;
		private static var referenceManager:ReferenceManager;
		private static var scopeManager:ScopeManager;
		private static var controllerManager:ControllerUtil;
		private static var measureBracket:MeasurementBracketUtil;
		private static var consoleMenu:ContextMenu;
		
		public function ContextMenuUtil() {
		
		}
		
		public static function setUp(console:DConsole, root:DisplayObjectContainer = null):void {
			getReferences(console);
			
			consoleMenu = new ContextMenu();
			var screenshotItem:ContextMenuItem = new ContextMenuItem("Screenshot");
			screenshotItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, console.screenshot);
			var toggleDisplayItem:ContextMenuItem = new ContextMenuItem("Hide");
			toggleDisplayItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, console.toggleDisplay);
			var toggleStatsItem:ContextMenuItem = new ContextMenuItem("Performance stats");
			toggleStatsItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, console.toggleStats);
			consoleMenu.customItems.push(toggleDisplayItem);
			consoleMenu.customItems.push(toggleStatsItem);
			consoleMenu.customItems.push(screenshotItem);
			console.contextMenu = consoleMenu;
			
			if (!root)
				return;
			var toggleMenuItem:ContextMenuItem = new ContextMenuItem("Toggle console");
			toggleMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onConsoleToggle, false, 0, true);
			var selectionMenuItem:ContextMenuItem = new ContextMenuItem("Set console scope");
			selectionMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSelectionMenu, false, 0, true);
			var controllerMenuItem:ContextMenuItem = new ContextMenuItem("Create controller");
			controllerMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onControllerMenu, false, 0, true);
			var referenceMenuItem:ContextMenuItem = new ContextMenuItem("Create reference");
			referenceMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onReferenceMenu, false, 0, true);
			var measureMenuItem:ContextMenuItem = new ContextMenuItem("Get measurements");
			measureMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMeasureMenu, false, 0, true);
			
			var baseMenu:ContextMenu = new ContextMenu();
			baseMenu.customItems.push(toggleMenuItem);
			baseMenu.customItems.push(selectionMenuItem);
			baseMenu.customItems.push(controllerMenuItem);
			baseMenu.customItems.push(referenceMenuItem);
			baseMenu.customItems.push(measureMenuItem);
			
			if (!root.contextMenu)
				root.contextMenu = new ContextMenu();
			root.contextMenu = baseMenu;
		}
		
		private static function getReferences(c:DConsole):void {
			console = c;
			var a:Array = console.getManagerRefs();
			scopeManager = a[0];
			referenceManager = a[1];
			controllerManager = a[2];
			measureBracket = a[3];
		}
		
		private static function onConsoleToggle(e:ContextMenuEvent):void {
			console.toggleDisplay();
		}
		
		private static function onMeasureMenu(e:ContextMenuEvent):void {
			var target:DisplayObject = e.mouseTarget;
			if (target != console.root) {
				measureBracket.bracket(target);
			} else {
				console.print("Unable to bracket root", ConsoleMessageTypes.ERROR);
			}
			console.show();
		}
		
		private static function onReferenceMenu(e:ContextMenuEvent):void {
			var target:DisplayObject = e.mouseTarget;
			console.show();
			referenceManager.createReference(target);
		}
		
		private static function onControllerMenu(e:ContextMenuEvent):void {
			var target:DisplayObject = e.mouseTarget;
			if (target is DisplayObject) {
				console.show();
				if (target == console.root) {
					console.print("Unable to create default controller for root", ConsoleMessageTypes.ERROR);
					return;
				}
				scopeManager.setScope(target);
				var properties:Array = ["name", "x", "y", "width", "height", "rotation", "scaleX", "scaleY"];
				if (target is TextField) {
					properties.unshift("text");
					properties.unshift("autoSize");
				}
				var p:Point = new Point(e.mouseTarget.x, e.mouseTarget.y);
				p = e.mouseTarget.localToGlobal(p);
				controllerManager.createController(scopeManager.currentScope.obj, properties, p.x + 20, p.y + 20);
				console.minimize();
				console.print("Controller created. Type values to alter, or use the mousewheel on numbers.");
			}
		}
		
		private static function onSelectionMenu(e:ContextMenuEvent):void {
			scopeManager.setScope(e.mouseTarget);
		}
	}

}
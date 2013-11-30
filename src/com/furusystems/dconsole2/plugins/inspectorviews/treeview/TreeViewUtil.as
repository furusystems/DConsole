package com.furusystems.dconsole2.plugins.inspectorviews.treeview 
{
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.Message;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.style.Alphas;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.buttons.EyeDropperButton;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.dfs.DFS;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.noderenderers.ListNode;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class TreeViewUtil extends AbstractInspectorView implements IRenderable,IThemeable
	{
		private var _console:IConsole;
		private var _pm:PluginManager;
		
		protected var _root:DisplayObjectContainer;
		protected var _rootNode:ListNode;
		
		protected var _mouseSelectButton:EyeDropperButton;
		public function TreeViewUtil() 
		{
			super("Display list");
			_mouseSelectButton = new EyeDropperButton();
			//addChild(_mouseSelectButton).y = 2; //TODO: Show button when functionality implemented
			_mouseSelectButton.addEventListener(MouseEvent.MOUSE_DOWN, activateMouseSelect);
		}
		
		private function onScopeChangeComplete():void 
		{
			consolidateSelection();
		}
		
		private function consolidateSelection():void 
		{
			if (_pm.scopeManager.currentScope.targetObject is DisplayObject) {
				//trace("\tIt's a display object");
				if (DisplayObject(_pm.scopeManager.currentScope.targetObject).stage != null) {
					//trace("\tIt's on stage");
					if (ListNode.table[_pm.scopeManager.currentScope.targetObject] != null) {
						//trace("\tThere's a node for it");
						select(_pm.scopeManager.currentScope.targetObject as DisplayObject);
					}else {
						//trace("\tThere is no node for it");
					}
				}
			}else {
				//trace("NEGATIVE");
				clearSelection();
			}
		}
		
		public function clearSelection():void 
		{
			ListNode.clearSelections();
		}
		
		private function activateMouseSelect(e:MouseEvent):void 
		{
			
		}
		public function setSelection(node:ListNode):void {
			select(node.displayObject);
			//scrollTo(node);
		}
		public function render():void
		{
			if (!_rootNode) return;
			var rect:Rectangle = inspector.dims.clone();
			rect.height -= GUIUnits.SQUARE_UNIT;
			scrollRect = rect;
			_rootNode.render();
			graphics.clear();
			graphics.beginFill(Colors.TREEVIEW_BG, Alphas.TREEVIEW_BG_ALPHA);
			graphics.drawRect(0, 0, scrollRect.width, scrollRect.height);
		}
		
		public function set rootNode(value:DisplayObjectContainer):void 
		{
			if (_rootNode) {
				content.removeChild(_rootNode);
			}
			ListNode.clearTable();
			_rootNode = new ListNode(value, null, this);
			content.addChildAt(_rootNode, 0);
			render();
			scrollByDelta(0, 0);
		}
		override public function scrollByDelta(x:Number, y:Number):void 
		{
			if (!_rootNode) return;
			super.scrollByDelta(x, y);
		}
		override public function get maxScrollY():Number {
			var rect:Rectangle = _rootNode.transform.pixelBounds;
			return rect.height-scrollRect.height;
		}
		override public function get maxScrollX():Number {
			var rect:Rectangle = _rootNode.transform.pixelBounds;
			return rect.width-scrollRect.width;
		}
		override protected function calcBounds():Rectangle 
		{
			return _bounds = _rootNode.transform.pixelBounds;
		}
		override protected function onShow():void 
		{
			populate(stage);
			consolidateSelection();
			super.onShow();
		}
		public function rebuild():void {
			
		}
		public function select(target:DisplayObject):void {
			//trace("Select: " + target);
			var node:ListNode;
			if (ListNode.table[target] != null) {
				//not found
				node = ListNode.table[target];
			}else {
				node = DFS.search(target, _rootNode);
			}
			//collapseAll();
			if (!node) return;
			while (node.parentNode != null) {
				node = node.parentNode;
				node.expanded = true;
			}
			render();
			scrollTo(ListNode.table[target]);
			ListNode.table[target].selected = true;
		}
		public function collapseAll():void {
			for each (var node:ListNode in ListNode.table) 
			{
				node.expanded = false;
			}
		}
		public function scrollTo(node:ListNode):void {
			//TODO: Refine targeting; Target should be framed center
			var rect:Rectangle = node.getRect(this);
			var s:Rectangle = scrollRect;
			var diffX:Number = rect.x - (s.x + s.width * .5);
			var diffY:Number = (rect.y +node.firstLevelHeight * .5) - (s.y + s.height * .5);
			scrollByDelta(-diffX, -diffY);
		}
		
		public function onDisplayObjectSelected(displayObject:DisplayObject):void
		{
			_pm.messaging.send(Notifications.SCOPE_CHANGE_REQUEST, displayObject, this);
		}
		override public function populate(object:Object):void {
			if (object is DisplayObjectContainer) {
				rootNode = DisplayObjectContainer(object);
			}
		}
		override public function resize():void 
		{
			render();
			_mouseSelectButton.x = availableWidth - _mouseSelectButton.width - 2;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData):void
		{
			render();
			_mouseSelectButton.updateAppearance();
		}
		
		override public function get descriptionText():String { 
			return "Adds a tree view representing the current displaylist";
		}
		override public function initialize(pm:PluginManager):void 
		{
			_pm = pm;
			pm.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			pm.messaging.addCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChangeComplete);
			_console = pm.console;
			consolidateSelection();
			_console.createCommand("searchDlByName", searchDisplayListByName, "Display", "Searches the display list for a named display object");
			super.initialize(pm);
		}
		
		private function searchDisplayListByName(name:String):void 
		{
			for each(var dl:ListNode in ListNode.table) {
				if (dl.displayObject != null&&dl.displayObject.name!=null) {
					if (dl.displayObject.name.toLowerCase() == name.toLowerCase()) {
						_pm.messaging.send(Notifications.SCOPE_CHANGE_REQUEST, dl.displayObject);
						return;
					}
				}
			}
		}
		public override function shutdown(pm:PluginManager):void 
		{
			_console.removeCommand("searchDlByName");
			pm.messaging.removeCallback(Notifications.THEME_CHANGED, onThemeChange);
			pm.messaging.removeCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChangeComplete);
			_pm = null;
			_console = null;
			super.shutdown(pm);
		}
	}
}
package com.furusystems.dconsole2.plugins.inspectorviews.treeview.noderenderers
{
	import com.furusystems.dconsole2.core.style.TextColors;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import com.furusystems.dconsole2.core.gui.AbstractButton;
	import com.furusystems.dconsole2.core.style.BaseColors;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.buttons.*;
	import com.furusystems.dconsole2.plugins.inspectorviews.treeview.TreeViewUtil;
	
	public final class ListNode extends Sprite implements INodeRenderer
	{
		public static var table:Dictionary = new Dictionary(true);
		private static var lastSelected:ListNode = null;
		
		private var displayObjectReference:Dictionary = new Dictionary(true);
		private var _labelField:TextField;
		private var _name:String;
		private var _selected:Boolean = false;
		private var _selectedOverlay:Shape;
		private var childContainer:Sprite = new Sprite();
		private var _firstLevelHeight:Number = 0;
		
		public var parentNode:ListNode;
		public var expanded:Boolean = false;
		public var treeView:TreeViewUtil;
		public var childNodes:Vector.<ListNode>;
		
		private var minusButton:AbstractButton = new Minusbutton();
		private var plusButton:AbstractButton = new Plusbutton();
		
		public function get displayObject():DisplayObject {
			if (displayObjectReference[0] != null) return DisplayObject(displayObjectReference[0]);
			throw new Error("Display object reference is null");
		}
		public static function clearSelections():void {
			for each(var l:ListNode in table) {
				l.selected = false;
			}
		}
		
		public static function clearTable():void 
		{
			table = new Dictionary(true);
			lastSelected = null;
		}
		public function set displayObject(d:DisplayObject):void {
			
			displayObjectReference[0] = d;
		}
		public function ListNode(displayObject:DisplayObject, parent:ListNode, treeView:TreeViewUtil)
		{
			this.displayObject = displayObject;
			this.treeView = treeView;
			parentNode = parent;
			table[displayObject] = this;
			_name = getQualifiedClassName(displayObject).split("::").pop();
			
			addChild(childContainer);
			
			_labelField = new TextField();
			_labelField.autoSize = TextFieldAutoSize.LEFT;
			_labelField.defaultTextFormat = TextFormats.windowDefaultFormat;
			_labelField.textColor = Colors.TREEVIEW_FG;
			_labelField.embedFonts = true;
			_labelField.selectable = false;
			_labelField.addEventListener(MouseEvent.CLICK, onClick);
			//_labelField.doubleClickEnabled = true;
			//_labelField.addEventListener(MouseEvent.DOUBLE_CLICK, onDClick);
			addChild(_labelField);
			
			setLabel();
			
			//_selectedOverlay = new Shape();
			//_selectedOverlay.blendMode = BlendMode.INVERT;
			//_selectedOverlay.visible = _selected;
			//addChild(_selectedOverlay);
			addChild(plusButton);
			addChild(minusButton);
			plusButton.visible = minusButton.visible = false;
			
			plusButton.addEventListener(MouseEvent.CLICK, onPlusClick, false, 0, true);
			minusButton.addEventListener(MouseEvent.CLICK, onMinusClick, false, 0, true);
			buildChildren();
		}
		
		private function onMinusClick(e:MouseEvent):void 
		{
			expanded = false;
			//treeView.setSelection(this);
			treeView.render();
			treeView.scrollTo(this);
		}
		
		private function onPlusClick(e:MouseEvent):void 
		{
			expanded = true;
			treeView.render();
			treeView.scrollTo(this);
		}
		private function onClick(e:MouseEvent):void 
		{
			treeView.onDisplayObjectSelected(displayObject);
		}
		private function onMouseOut(e:MouseEvent):void 
		{
			//treeView.insp.clearHighlight();
		}
		private function onMouseOver(e:MouseEvent):void 
		{
			//TODO: Some kind of highlight of the target
			//treeView.insp.highlightTarget(displayObject);
		}
		public function dispose():void {
			_labelField.removeEventListener(MouseEvent.CLICK, onClick);
			//_labelField.addEventListener(MouseEvent.DOUBLE_CLICK, onDClick);
		}
		
		/* INTERFACE inspector.treeview.IRenderable */
		
		public function render():void
		{
			_labelField.textColor = _selected?TextColors.TEXT_INFO:TextColors.TEXT_AUX;
			graphics.clear();
			graphics.lineStyle(0, Colors.TREEVIEW_FG);
			clear();
			if (parentNode) {
				graphics.moveTo(0, 7);
				graphics.lineTo( -7, 7);
			}
			setLabel();
			if (expanded) {
				if(!childNodes) buildChildren();
				var y:Number = height;
				graphics.moveTo(8, y);
				var lasty:Number = 0;
				for (var i:int = 0; i < childNodes.length; i++) 
				{
					childContainer.addChild(childNodes[i]).y = y;
					childNodes[i].x = 15;
					childNodes[i].render();
					lasty = lasty < y?y:lasty;
					y += childNodes[i].height;
				}
				graphics.lineTo(8, lasty + 8);
				_firstLevelHeight = lasty + 8;
				
			}
		}
		public function refresh():void {
		
		}
		
		private function setLabel():void
		{
			_labelField.text = _name;
			minusButton.x = plusButton.x = _labelField.width+1;
			minusButton.y = plusButton.y = Math.round(_labelField.height * .5 - plusButton.height * .5);
			if (displayObject is DisplayObjectContainer) {
				if (displayObject is DConsole&&DConsole.CONSOLE_SAFE_MODE) {
					mouseEnabled = mouseChildren = false;
					_labelField.alpha = 0.4;
					return;
				}
				if (hasChildren) {
					if (expanded) {
						minusButton.visible = !(plusButton.visible = false);
					}else {
						minusButton.visible = !(plusButton.visible = true);
					}
				}
			}
		}
		private function clearChildren():void {
			for (var i:int = 0; i < childNodes.length; i++) 
			{
				childNodes[i].dispose();
			}
			childNodes = new Vector.<ListNode>();
		}
		public function buildChildren():void
		{
			if (childNodes) return;
			childNodes = new Vector.<ListNode>();
			if (!hasChildren) return;
			if (displayObject is DisplayObjectContainer) {
				for (var i:int = 0; i < DisplayObjectContainer(displayObject).numChildren; i++) 
				{
					var c:DisplayObject = DisplayObjectContainer(displayObject).getChildAt(i);
					childNodes.push(new ListNode(c, this, treeView));
				}
			}
		}
		private function get hasChildren():Boolean {
			if (displayObject is DisplayObjectContainer) {
				var doc:DisplayObjectContainer = DisplayObjectContainer(displayObject);
				return doc.numChildren > 0;
			}
			return false;
		}
		private function clear():void {
			while (childContainer.numChildren > 0) {
				childContainer.removeChildAt(0);
			}
		}
		
		public function expand():void {
			expanded = true;
			render();
		}
		public function collapse():void {
			expanded = false;
			render();
		}
		/**
		 * Test children for existence, if discrepancy is found, rebuild
		 */
		public function validate():Boolean {
			return true;
		}
		
		public function get selected():Boolean { return _selected; }
		
		/**
		 * Sets wether this is the currently selected item in the tree
		 */
		public function set selected(value:Boolean):void 
		{
			if (_selected == value) return;
			if (lastSelected && lastSelected != this) lastSelected.selected = false;
			var rect:Rectangle = _labelField.getRect(this);
			_selected = value;
			_labelField.textColor = _selected?TextColors.TEXT_INFO:TextColors.TEXT_AUX;
			//_selectedOverlay.graphics.clear();
			//_selectedOverlay.graphics.beginFill(BaseColors.BLACK);
			//_selectedOverlay.graphics.drawRect(0, 0, hasChildren?rect.width + 12:rect.width, rect.height);
			//_selectedOverlay.graphics.endFill();
			lastSelected = this;
		}
		
		/**
		 * Returns the height of the root item sans children
		 */
		public function get firstLevelHeight():Number { return _firstLevelHeight; }
		
	}

}
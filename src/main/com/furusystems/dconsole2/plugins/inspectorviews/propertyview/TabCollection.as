package com.furusystems.dconsole2.plugins.inspectorviews.propertyview 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.tabs.PropertyTab;
	/**
	 * ...
	 * @author Andreas Ronning 
	 */
	public class TabCollection extends Sprite
	{
		private const _tabs:Vector.<PropertyTab> = new Vector.<PropertyTab>();
		private var _currentSelection:PropertyTab = null;
		public var singleSelectionOnly:Boolean = false;
		public function TabCollection() 
		{
			
		}
		public function add(t:PropertyTab):void {
			_tabs.push(t);
			addChild(t);
			t.addEventListener(Event.CHANGE, onTabChange);
			update();
		}
		private function onTabChange(e:Event):void 
		{
			if(singleSelectionOnly){
				var t:PropertyTab = e.currentTarget as PropertyTab;
				for (var i:int = 0; i < _tabs.length; i++) 
				{
					if (_tabs[i] == t) continue;
					_tabs[i].expanded = false;
				}
			}
			update();
		}
		public function update(updateAppearance:Boolean = false):void
		{
			var h:Number = 0
			for (var i:int = 0; i < _tabs.length; i++) 
			{
				var t:PropertyTab = _tabs[i];
				if (updateAppearance) t.updateAppearance();
				t.y = h;
				h += t.height + GUIUnits.V_MARGIN;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function clear():void {
			while (_tabs.length > 0) {
				var t:PropertyTab = _tabs.pop();
				t.removeEventListener(Event.CHANGE, onTabChange);
				removeChild(t);
			}
		}
		
		public function updateTabs():void
		{
			for (var i:int = _tabs.length; i--; ) 
			{
				_tabs[i].updateFields();
			}
		}
		override public function get width():Number { return super.width; }
		
		override public function set width(value:Number):void 
		{
			for (var i:int = 0; i < _tabs.length; i++) 
			{
				_tabs[i].width = value;
			}
		}
		
	}

}
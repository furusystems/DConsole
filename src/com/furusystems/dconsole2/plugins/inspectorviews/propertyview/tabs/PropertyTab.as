package com.furusystems.dconsole2.plugins.inspectorviews.propertyview.tabs
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes.PropertyField;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.TabContent;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class PropertyTab extends Sprite
	{
		protected var headerField:TextField;
		protected var headerBar:Sprite = new Sprite();
		protected var contents:Sprite = new Sprite();
		protected var _expanded:Boolean;
		protected var _contentFields:Vector.<TabContent> = new Vector.<TabContent>();
		private var _prevWidth:Number = 0;
		public function PropertyTab(title:String,startsExpanded:Boolean = false) 
		{
			headerField = new TextField();
			headerField.height = GUIUnits.SQUARE_UNIT;
			headerField.defaultTextFormat = TextFormats.windowDefaultFormat;
			headerField.embedFonts = true;
			headerField.textColor = Colors.INSPECTOR_TAB_HEADER_FG;
			headerField.text = title;
			contents.y = GUIUnits.SQUARE_UNIT + GUIUnits.V_MARGIN;
			headerBar.addChild(headerField);
			headerField.mouseEnabled = false;
			headerBar.buttonMode = true;
			headerBar.addEventListener(MouseEvent.CLICK, toggleExpanded);
			addChild(headerBar);
			expanded = startsExpanded;
		}
		public function addField(p:TabContent):TabContent {
			p.addEventListener(Event.CHANGE, onPropertyFieldSplitChange,false,0,true);
			_contentFields.push(p);
			render(_prevWidth); //TODO: SOme optimization here? 
			return p;
		}
		public function sortFields():void {
			_contentFields.sort(sortAlphabetical);
			render(_prevWidth);
		}
		
		private function sortAlphabetical(a:TabContent,b:TabContent):int
		{
			if (a.title > b.title) return 1;
			if (a.title < b.title) return -1;
			return 0;
		}
		public function averageSplits():void {
			var tally:Number = 0;
			for each(var p:PropertyField in _contentFields) {
				p.splitToName();
				tally += p.splitRatio;
			}
			tally /= _contentFields.length;
			tally += 0.1; //slight bias
			for each(p in _contentFields) {
				p.splitRatio = tally;
			}
		}
		
		private function onPropertyFieldSplitChange(e:Event):void 
		{
			if (e.target is PropertyField) {
				var newSplit:Number = PropertyField(e.target).splitRatio;
				for (var i:int = _contentFields.length; i--; ) 
				{
					if (_contentFields[i] is PropertyField) {
						PropertyField(_contentFields[i]).splitRatio = newSplit;
					}
				}
			}
		}
		
		private function updateLayout(updateAppearance:Boolean = false):void
		{
			var h:Number = 0;
			for (var i:int = 0; i < _contentFields.length; i++) 
			{
				var c:TabContent = _contentFields[i];
				if (updateAppearance) c.updateAppearance();
				contents.addChild(c).y = h;
				h += Math.ceil(c.height) + GUIUnits.V_MARGIN;
				c.width = _prevWidth;
			}
		}
		override public function get width():Number { return super.width; }
		
		override public function set width(value:Number):void 
		{
			render(value);
		}
		private function toggleExpanded(e:MouseEvent):void 
		{
			expanded = !expanded;
			dispatchEvent(new Event(Event.CHANGE));
		}
		override public function get height():Number { 
			if (_expanded) {
				return super.height; 
			}else {
				return headerBar.height;
			}
		}
		public function updateAppearance():void {
			render(_prevWidth, true);
		}
		
		public function updateFields():void
		{
			if (!_expanded) return;
			for (var i:int = _contentFields.length; i--; ) 
			{
				_contentFields[i].updateFromSource();
			}
		}
		private function render(w:Number, updateAppearance:Boolean = false):void {
			headerField.textColor = Colors.INSPECTOR_TAB_HEADER_FG;
			if(w!=_prevWidth||updateAppearance){
				headerBar.graphics.clear();
				headerBar.graphics.beginFill(Colors.INSPECTOR_TAB_HEADER_BG);
				headerBar.graphics.drawRect(0, 0, w, GUIUnits.SQUARE_UNIT);
				headerBar.graphics.endFill();
				headerField.width = w;
				contents.graphics.clear();
				contents.graphics.beginFill(Colors.INSPECTOR_TAB_CONTENT_BG);
				contents.graphics.drawRect(0, 0, w, getNumProperties() * (GUIUnits.SQUARE_UNIT+GUIUnits.V_MARGIN));
				contents.graphics.endFill();
			}
			//contents.scrollRect = new Rectangle(0, 0, w, getNumProperties() * GUIUnits.SQUARE_UNIT);
			_prevWidth = w;
			updateLayout(updateAppearance);
		}
		private function getNumProperties():int {
			return _contentFields.length;
		}
		public function get expanded():Boolean { return _expanded; }
		
		public function set expanded(value:Boolean):void 
		{
			_expanded = value;
			if (_expanded) {
				addChild(contents);
			}else {
				if (!contains(contents)) return;
				removeChild(contents);
			}
		}
		
	}

}
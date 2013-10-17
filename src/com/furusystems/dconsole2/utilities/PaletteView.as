package com.furusystems.dconsole2.utilities 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class PaletteView extends Sprite
	{
		
		private var _selectedSwatch:ColorSwatch = null;
		private var rowLength:int;
		private var nameField:TextField = new TextField();
		private var swatchContainer:Sprite = new Sprite();
		private var configurer:ThemeConfigurer;
		public function PaletteView(rowLength:int = 8) 
		{
			this.rowLength = rowLength;
			addChild(swatchContainer);
			addChild(nameField);
			nameField.height = 22;
			nameField.width = 120;
			nameField.background = true;
			nameField.border = true;
			nameField.text = "Bahh";
			nameField.addEventListener(Event.CHANGE, onTextchange);
		}
		public function setConfigurer(p:ThemeConfigurer):void {
			this.configurer = p;
		}
		
		private function onTextchange(e:Event):void 
		{
			if (_selectedSwatch != null) {
				_selectedSwatch.color.name = nameField.text;
			}
		}
		
		public function setColors(colors:Vector.<ColorDef>):void 
		{
			clear();
			for each(var c:ColorDef in colors){
				var swatch:ColorSwatch = new ColorSwatch(c);
				swatchContainer.addChild(swatch);
				swatch.addEventListener(MouseEvent.MOUSE_DOWN, onSwatchClicked);
				swatch.addEventListener(Event.CHANGE, onSwatchChange);
			}
			layout();
		}
		
		private function onSwatchClicked(e:MouseEvent):void 
		{
			setSelectedSwatch(e.currentTarget as ColorSwatch);
			
		}
		private function setSelectedSwatch(swatch:ColorSwatch):void {
			if (_selectedSwatch != null) {
				_selectedSwatch.selected = false;
			}
			_selectedSwatch = swatch;
			nameField.text = _selectedSwatch.color.name;
			_selectedSwatch.selected = true;
			if (configurer.prevSelection) {
				configurer.prevSelection.text = nameField.text;
				configurer.prevSelection.backgroundColor = getColorByName(nameField.text);
			}
		}
		
		private function clear():void 
		{
			while (swatchContainer.numChildren > 0) {
				swatchContainer.removeChildAt(0).removeEventListener(MouseEvent.MOUSE_DOWN, onSwatchClicked);
			}
		}
		public function addSwatch(color:ColorDef):void {
			var swatch:ColorSwatch = new ColorSwatch(color);
			swatchContainer.addChild(swatch);
			swatch.addEventListener(MouseEvent.MOUSE_DOWN, onSwatchClicked);
			swatch.addEventListener(Event.CHANGE, onSwatchChange);
			layout();
		}
		private function onSwatchChange(e:Event):void 
		{
			var swatch:ColorSwatch = e.currentTarget as ColorSwatch;
			configurer.updateColor(swatch.color);
		}
		public function removeSwatch(swatch:ColorSwatch):void {
			swatchContainer.removeChild(swatch);
			swatch.removeEventListener(MouseEvent.MOUSE_DOWN, onSwatchClicked);
			swatch.removeEventListener(Event.CHANGE, onSwatchChange);
			layout();
		}
		
		private function layout():void 
		{
			var x:int = 0;
			var y:int = 0;
			for (var i:int = 0; i < swatchContainer.numChildren; i++) {
				swatchContainer.getChildAt(i).x = x * ((ColorSwatch.RADIUS<<1)+2);
				swatchContainer.getChildAt(i).y = y * ((ColorSwatch.RADIUS<<1)+2);
				x++;
				if (x > rowLength) {
					x = 0;
					y++;
				}
			}
			nameField.y = swatchContainer.height + 2;
		}
		
		public function get selectedSwatch():ColorSwatch 
		{
			return _selectedSwatch;
		}
		public function save():XML {
			var xml:XML = new XML(<data/>);
			for (var i:int = swatchContainer.numChildren; i--; ) {
				var swatch:ColorSwatch = swatchContainer.getChildAt(i) as ColorSwatch;
				var n:XML = new XML(<{swatch.color.name}>{swatch.color.color.toString(16)}</{swatch.color.name}>);
				xml.appendChild(n);
			}
			return xml;
		}
		
		public function getColorByName(name:String):uint
		{
			for (var i:int = swatchContainer.numChildren; i--; ) {
				var swatch:ColorSwatch = swatchContainer.getChildAt(i) as ColorSwatch;
				if (swatch.color.name.toLowerCase() == name.toLowerCase()) {
					return swatch.color.color;
				}
			}
			return 0;
		}
		
		public function selectSwatchByName(name:String):void 
		{
			for (var i:int = swatchContainer.numChildren; i--; ) {
				var swatch:ColorSwatch = swatchContainer.getChildAt(i) as ColorSwatch;
				if (swatch.color.name.toLowerCase() == name.toLowerCase()) {
					setSelectedSwatch(swatch); 
					return;
				}
			}
		}
		
	}

}

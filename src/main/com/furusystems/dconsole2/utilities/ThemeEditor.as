package com.furusystems.dconsole2.utilities {
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class ThemeEditor extends Sprite {
		private var _console:IConsole;
		private var _colors:XML;
		private var _theme:XML;
		
		//TEMP
		[Embed(source='../core/style/themes/solarized/solarized_colors.xml',mimeType='application/octet-stream')]
		private var DEFAULT_COLOR_XML:Class;
		[Embed(source='../core/style/themes/solarized/solarized_dark.xml',mimeType='application/octet-stream')]
		private var DEFAULT_THEME_XML:Class;
		private var _colorSelector:ColorSelector;
		private var palette:PaletteView;
		private var themeConfig:ThemeConfigurer;
		
		//
		public function ThemeEditor(console:IConsole) {
			_console = console;
			
			//graphics.beginFill(0, 1);
			//graphics.drawRect(0, 0, 320, 240);
			
			_colorSelector = new ColorSelector(320, 240);
			addChild(_colorSelector);
			_colorSelector.addEventListener(MouseEvent.MOUSE_DOWN, onColorPick);
			
			palette = new PaletteView(8);
			addChild(palette);
			palette.y = _colorSelector.height + 4;
			palette.x = 4;
			
			themeConfig = new ThemeConfigurer(palette);
			addChild(themeConfig).x = _colorSelector.width + 4;
			palette.setConfigurer(themeConfig);
			
			//TEMP
			populate(XML(new DEFAULT_COLOR_XML), XML(new DEFAULT_THEME_XML));
		}
		
		private function onColorPick(e:MouseEvent):void {
			if (palette.selectedSwatch != null) {
				palette.selectedSwatch.setColor(_colorSelector.lookUp(_colorSelector.mouseX, _colorSelector.mouseY));
			}
		}
		
		public function populate(colors:XML, theme:XML):void {
			clear();
			_colors = colors;
			_theme = theme;
			createPalette();
			createTree();
		}
		
		private function createPalette():void {
			var colors:Vector.<ColorDef> = new Vector.<ColorDef>();
			for each (var xml:XML in _colors.*) {
				colors.push(new ColorDef(xml.name(), uint(String(xml))));
			}
			palette.setColors(colors);
		}
		
		private function createTree():void {
			themeConfig.populate(_theme);
		}
		
		private function clear():void {
			//remove all components etc
		}
		
		public function applyTheme():void {
			_console.setTheme(palette.save(), themeConfig.save());
		}
	
	}

}
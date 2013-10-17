package com.furusystems.dconsole2.core.style 
{
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.themes.ConsoleTheme;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class StyleManager
	{
		//[Embed(source='themes/default.xml',mimeType='application/octet-stream')]
		[Embed(source='themes/black/black.xml',mimeType='application/octet-stream')]
		private var DEFAULT_THEME_XML:Class;
		//[Embed(source='themes/default_colors.xml',mimeType='application/octet-stream')]
		[Embed(source='themes/black/black_colors.xml',mimeType='application/octet-stream')]
		private var DEFAULT_COLOR_DESC_XML:Class;
		
		private var _colorsLoaded:Boolean;
		private var _themeLoaded:Boolean;
		public var colors:ColorCollection = new ColorCollection();
		public var theme:ConsoleTheme;
		private var _themeLoader:URLLoader;
		private var _colorLoader:URLLoader;
		private var _loadTally:int = 0;
		private var _loadTallyTarget:int = 0;
		private var _messaging:PimpCentral;
		public function StyleManager(console:DConsole) 
		{
			_messaging = console.messaging;
			theme = new ConsoleTheme(this);
			_themeLoader = new URLLoader();
			_themeLoader.addEventListener(Event.COMPLETE, onThemeLoaded);
			_colorLoader = new URLLoader();
			_colorLoader.addEventListener(Event.COMPLETE, onColorsLoaded);
		}
		public function load(themeURI:String = null, colorsURI:String = null):void {
			_loadTallyTarget = 0;
			if (colorsURI == null) {
				setColors();
			}else {
				loadColors(colorsURI);
			}
			if (themeURI == null) {
				setTheme();
			}else {
				loadTheme(themeURI);
			}
			if (_loadTallyTarget == 0) consolidateStyle();
		}
		
		public function setThemeXML (colors:XML, theme:XML):void 
		{
			setColors(colors);
			setTheme(theme);
			consolidateStyle();
		}
		
		private function onColorsLoaded(e:Event):void 
		{
			setColors(XML(_colorLoader.data));
			loadTally++;
		}
		
		private function onThemeLoaded(e:Event):void 
		{
			setTheme(XML(_themeLoader.data));
			loadTally++;
		}
		private function set loadTally(n:int):void {
			_loadTally = n;
			if (_loadTally >= _loadTallyTarget) {
				consolidateStyle();
			}
		}
		private function get loadTally():int {
			return _loadTally;
		}
		
		private function loadTheme(themeURI:String):void
		{
			_loadTallyTarget++;
			_themeLoader.load(new URLRequest(themeURI));
		}
		
		private function loadColors(colorsURI:String):void
		{
			_loadTallyTarget++;
			_colorLoader.load(new URLRequest(colorsURI));
		}
		
		private function setColors(input:XML = null):void {
			_colorsLoaded = true;
			if (input == null) {
				input = XML(new DEFAULT_COLOR_DESC_XML());
			}else {
				DConsole.print("Custom color scheme loaded");
			}
			colors.populate(input);
			_messaging.send(Notifications.COLOR_SCHEME_CHANGED, null, this);
		}
		private function setTheme(input:XML = null):void {
			_themeLoaded = true;
			if (input == null) {
				input = XML(new DEFAULT_THEME_XML());
			}else {
				DConsole.print("Custom theme loaded");
			}
			theme.populate(input);
			Alphas.update(this);
			Colors.update(this);
			TextColors.update(this);
		}
		
		private function consolidateStyle():void
		{
			TextFormats.refresh();
			_messaging.send(Notifications.THEME_CHANGED, null, this);
		}
		
		public function get themeXML():XML {
			return theme.xml;
		}
		public function get colorXML():XML {
			return colors.xml;
		}
		
		public function get themeLoaded():Boolean { return _themeLoaded; }
		
		public function get colorsLoaded():Boolean { return _colorsLoaded; }
		
	}

}
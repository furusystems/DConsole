package com.furusystems.dconsole2.core.gui.maindisplay.toolbar 
{
	import com.furusystems.dconsole2.core.gui.layout.IContainable;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ConsoleToolbar extends Sprite implements IContainable,IThemeable
	{
		
		private var _titleField:TextField = new TextField();
		private var _rect:Rectangle;
		private var _console:IConsole;
		public function ConsoleToolbar(console:IConsole) 
		{
			_console = console;
			_titleField.height = GUIUnits.SQUARE_UNIT;
			_titleField.selectable = _titleField.mouseEnabled = false;
			_titleField.defaultTextFormat = TextFormats.consoleTitleFormat;
			_titleField.embedFonts = true;
			_titleField.textColor = Colors.HEADER_FG;
			_titleField.text = "Doomsday Console II";
			_titleField.x = _titleField.y = 1;
			addChild(_titleField);
			_console.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			
		}
		public function setTitle(text:String):void {
			_titleField.text = text;
		}
		/* INTERFACE com.furusystems.dconsole2.core.gui.layout.IContainable */
		
		public function onParentUpdate(allotedRect:Rectangle):void
		{
			_rect = allotedRect;
			//x = _rect.x;
			//y = _rect.y;
			graphics.clear();
			graphics.beginFill(Colors.HEADER_BG);
			graphics.drawRect(0, 0, _rect.width, GUIUnits.SQUARE_UNIT);
			graphics.endFill();
			_titleField.width = allotedRect.width;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData):void
		{
			_titleField.textColor = Colors.HEADER_FG;
			graphics.clear();
			graphics.beginFill(Colors.HEADER_BG);
			graphics.drawRect(0, 0, _rect.width, GUIUnits.SQUARE_UNIT);
			graphics.endFill();
		}
		
		public function get minHeight():Number
		{
			return 0;
		}
		
		public function get minWidth():Number
		{
			return 0;
		}
		
		public function get rect():Rectangle
		{
			return getRect(this);
		}
		
	}

}
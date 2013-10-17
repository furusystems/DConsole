package com.furusystems.dconsole2.core.gui.maindisplay.sections 
{
	import com.furusystems.dconsole2.core.gui.maindisplay.assistant.Assistant;
	import com.furusystems.dconsole2.core.gui.maindisplay.filtertabrow.FilterTabRow;
	import com.furusystems.dconsole2.core.gui.maindisplay.input.InputField;
	import com.furusystems.dconsole2.core.gui.maindisplay.output.OutputField;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class MainSection extends ConsoleViewSection
	{
		
		public var assistant:Assistant;
		public var filterTabs:FilterTabRow;
		public var input:InputField;
		public var output:OutputField;
		private var _console:DConsole;
		private var _r:Rectangle;
		private var _originalRect:Rectangle;
		public function MainSection(console:DConsole) 
		{
			_console = console;
			filterTabs = new FilterTabRow(console);
			output = new OutputField(console);
			input = new InputField(console);
			assistant = new Assistant(console);
			addChild(filterTabs);
			addChild(output);
			addChild(assistant);
			addChild(input);
			_console.messaging.addCallback(Notifications.NEW_LOG_CREATED, onLogCountChange, Notifications.LOG_DESTROYED);
		}
		
		private function onLogCountChange(md:MessageData):void
		{
			_r = _originalRect.clone();
			update();
		}
		override public function onParentUpdate(allotedRect:Rectangle):void 
		{
			_originalRect = allotedRect.clone();
			_r = _originalRect.clone();
			update();
		}
		
		public function update():void
		{
			if (!_r) return;
			var totalH:Number = _r.height;
			var totalW:Number = _r.width;
			var h:int = 0, w:Number = 0;
			var offsetX:Number = _r.x;
			var offsetY:Number = _r.y;
			x = offsetX;
			y = offsetY;
			
			filterTabs.visible = output.visible = assistant.visible = false;
			
			_r.x = _r.y = 0;
			
			assistant.visible = totalH > 2 * GUIUnits.SQUARE_UNIT;
			
			
			
			if (totalH > 3 * GUIUnits.SQUARE_UNIT && _console.logs.logsActive>1) { 
				//filtertabs enabled
				filterTabs.visible = true;
				filterTabs.onParentUpdate(_r);
				h += GUIUnits.SQUARE_UNIT;
			}
			if (totalH > 1 * GUIUnits.SQUARE_UNIT) {
				//output enabled
				output.visible = true;
				_r.y = h;
				var m:int = 3;
				if (!filterTabs.visible) m--;
				if (!assistant.visible) m--;
				//var m:int = filterTabs.visible?3:2;
				_r.height = totalH - m * GUIUnits.SQUARE_UNIT;
				output.onParentUpdate(_r);
				h += output.height;
			}
			
			//input always enabled
			if (!assistant.visible) {
				h = totalH - GUIUnits.SQUARE_UNIT;
			}
			_r.y = h;
			input.onParentUpdate(_r);
			h += input.height;
			
			if (assistant.visible) {
				//assistant enabled
				_r.y = h;
				assistant.onParentUpdate(_r);
			}
		}
		
	}

}
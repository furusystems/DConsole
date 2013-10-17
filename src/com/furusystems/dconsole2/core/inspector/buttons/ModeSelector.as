package com.furusystems.dconsole2.core.inspector.buttons {
	import com.furusystems.dconsole2.core.DSprite;
	import com.furusystems.dconsole2.core.gui.DropDown;
	import com.furusystems.dconsole2.core.gui.DropDownOption;
	import com.furusystems.dconsole2.core.gui.events.DropDownEvent;
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.IDConsoleInspectorPlugin;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ModeSelector extends DSprite implements IThemeable {
		private var modeMap:Dictionary = new Dictionary();
		//private var _buttons:Array = [];
		private var dropdown:DropDown;
		private var _messaging:PimpCentral;
		
		public function ModeSelector(console:IConsole) {
			_messaging = console.messaging;
			_messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			dropdown = new DropDown("Inspectors");
			addChild(dropdown);
			dropdown.addEventListener(DropDownEvent.SELECTION, onSelection, false, 0, true);
		}
		
		private function onSelection(e:DropDownEvent):void {
			setCurrentMode(e.selectedOption.data);
		}
		
		//private function onButtonClick(e:MouseEvent):void
		//{
		//var btn:AbstractButton = e.currentTarget as AbstractButton;
		//setCurrentMode(modeMap[btn]);
		//}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData):void {
			dropdown.updateAppearance();
			//for (var i:int = 0; i < _buttons.length; i++)
			//{
			//AbstractButton(_buttons[i]).updateAppearance();
			//}
		}
		
		public function addOption(v:IDConsoleInspectorPlugin):void {
			dropdown.addOption(new DropDownOption(v.title, v.view, true));
			//var btn:AbstractButton = createButton(v.tabIcon);
			//modeMap[btn] = v.view;
			//btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			//_buttons.push(btn);
			//removeAllChildren();
			//addChildren(_buttons, 0);
		}
		
		public function removeButton(v:IDConsoleInspectorPlugin):void {
			//TODO: Remove and clean up button and mapping
			dropdown.removeOption(v.title);
		}
		
		public function setCurrentMode(v:AbstractInspectorView):void {
			//for (var i:int = 0; i < _buttons.length; i++)
			//{
			//if (modeMap[_buttons[i]] == v) {
			//AbstractButton(_buttons[i]).active = true;
			//}else {
			//AbstractButton(_buttons[i]).active = false;
			//}
			//}
			dropdown.setCurrentSelection(v.title);
			_messaging.send(Notifications.INSPECTOR_MODE_CHANGE, v, this);
		}
	}

}
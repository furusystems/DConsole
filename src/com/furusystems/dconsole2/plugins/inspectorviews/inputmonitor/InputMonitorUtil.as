package com.furusystems.dconsole2.plugins.inspectorviews.inputmonitor 
{
	import com.furusystems.dconsole2.core.input.KeyboardManager;
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.introspection.descriptions.AccessorDesc;
	import com.furusystems.dconsole2.core.introspection.descriptions.ChildScopeDesc;
	import com.furusystems.dconsole2.core.introspection.descriptions.MethodDesc;
	import com.furusystems.dconsole2.core.introspection.descriptions.VariableDesc;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class InputMonitorUtil extends AbstractInspectorView implements IThemeable
	{
		
		private var kbm:KeyboardAccumulator = null;
		private var output:TextField;
		private var mouseDown:Boolean = false;
		private var pm:PluginManager;
		
		public function InputMonitorUtil() 
		{
			super("Input");
			scrollXEnabled = scrollYEnabled = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			output = new TextField();
			output.defaultTextFormat = TextFormats.consoleTitleFormat;
			output.embedFonts = true;
			//output.background = true;
			//output.backgroundColor = 0xFF0000;
			output.text = "";
			content.addChild(output);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			kbm = new KeyboardAccumulator(stage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			resize();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			mouseDown = false;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			mouseDown = true;
		}
		public override function shutdown(pm:PluginManager):void 
		{
			super.shutdown(pm);
			pm.messaging.removeCallback(Notifications.THEME_CHANGED, onThemeChange);
			this.pm = null;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			kbm.dispose();
			
		}
		override public function onFrameUpdate(e:Event = null):void 
		{
			if (!kbm) return;
			var out:String = "Stage mouse:\n";
			out += "\tx: " + stage.mouseX+"\n";
			out += "\ty: " + stage.mouseY+"\n";
			out += "\tLMB: " + mouseDown + "\n";
			if (pm.scopeManager.currentScope.targetObject is DisplayObject) {
				var d:DisplayObject = DisplayObject(pm.scopeManager.currentScope.targetObject);
				out += "Local mouse:\n";
				out += "\tx: " + d.mouseX + "\n";
				out += "\ty: " + d.mouseY + "\n";
				if(mouseDown){
					var hitTestResult:Boolean = d.hitTestPoint(stage.mouseX, stage.mouseY, false);
					var hitTestResult2:Boolean = d.hitTestPoint(stage.mouseX, stage.mouseY, true);
					out += "\thitTest: " + hitTestResult + "\n";
					out += "\thitTestShape: " + hitTestResult2 + "\n";
				}
			}
			out += "\n"+kbm.toString();
			output.text = out;
			//_tabs.updateTabs();
		}
		public override function initialize(pm:PluginManager):void 
		{
			super.initialize(pm);
			
			pm.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			this.pm = pm;
		}
		override public function populate(object:Object):void 
		{
		}
		override public function resize():void 
		{
			if (!inspector) return;
			var rect:Rectangle = inspector.dims.clone();
			output.width = rect.width;
			output.height = rect.height;
			rect.height -= GUIUnits.SQUARE_UNIT;
			//_tabs.width = rect.width;
			var r:Rectangle = scrollRect;
			r.width = rect.width;
			r.height = rect.height;
			scrollRect = r;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData):void
		{
		}
		
		override public function get descriptionText():String { 
			return "Adds a dynamically updating table of current mouse and keyboard inputs";
		}
		
		
	}

}
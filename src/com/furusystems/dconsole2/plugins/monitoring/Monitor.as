package com.furusystems.dconsole2.plugins.monitoring 
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import com.furusystems.dconsole2.core.gui.Window;
	import com.furusystems.dconsole2.core.style.TextFormats;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class Monitor extends Window
	{
		private var _scope:Dictionary = new Dictionary(true);
		public var properties:Array;
		public var outObj:Object = { };
		private var outputTf:TextField = new TextField();
		private var manager:MonitorManager;
		public function Monitor(manager:MonitorManager, scope:Object, properties:Array) 
		{
			this.manager = manager;
			_scope["scope"] = scope;
			this.properties = properties;
			outputTf.autoSize = TextFieldAutoSize.LEFT;
			outputTf.defaultTextFormat = TextFormats.windowDefaultFormat
			super(scope.toString(), new Rectangle(0, 0, 100, 100),outputTf,null,null,true,false,false);
			update(true);
		}
		public function get scope():*{
			return _scope["scope"];
		}
		public function update(redraw:Boolean = false):void {
			for (var i:int = 0; i < properties.length; i++) 
			{
				outObj[properties[i]] = scope[properties[i]];
			}
			outputTf.text = "";
			for (var s:String in outObj) {
				outputTf.appendText(s + " : " + outObj[s] + "\n");
			}
			if (redraw) {
				scaleToContents();
			}
		}
		public override function toString():String {
			return outObj.toString();
		}
		override protected function onClose(e:MouseEvent):void 
		{
			outObj = null;
			manager.removeMonitor(scope);
			super.onClose(e);
		}
		
	}

}
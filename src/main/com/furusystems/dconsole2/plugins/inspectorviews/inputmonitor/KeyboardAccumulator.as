package com.furusystems.dconsole2.plugins.inspectorviews.inputmonitor 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class KeyboardAccumulator 
	{
		private var _keys:Dictionary = new Dictionary();
		private var _stage:Stage;
		public function KeyboardAccumulator(stage:Stage)
		{
			this._stage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, int.MAX_VALUE);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, int.MAX_VALUE);
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			delete(_keys["" + e.keyCode]);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			_keys[""+e.keyCode] = e.charCode;
		}
		public function toString():String {
			var count:int = 0;
			var out:String = "Active keys:\n";
			for (var key:String in _keys) {
				count++;
				out += "\tkc"+key + " / " + "cc "+_keys[key] + "\n";
			}
			if (count > 0) return out;
			return "";
		}
		
		public function dispose():void 
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
	}

}
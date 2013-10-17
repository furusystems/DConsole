package com.furusystems.dconsole2.core.persistence 
{
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class PersistenceManager
	{
		private var _persistenceDataSO:SharedObject;
		private var _console:DConsole;
		public const MAX_HISTORY:int = 10;
		
		public var verticalSplitRatio:PersistentProperty;
		public var dockState:PersistentProperty;
		public var previousCommands:PersistentProperty;
		private var _width:PersistentProperty;
		private var _height:PersistentProperty;
		private var _x:PersistentProperty;
		private var _y:PersistentProperty;
		private var _commandIndex:int = 0;
		
		public function toString():String {
			var out:String = "Persistence:\n";
			out += "\t" + verticalSplitRatio+"\n";
			out += "\t" + dockState+"\n";
			out += "\t" + previousCommands+"\n";
			out += "\t" + _x+"\n";
			out += "\t" + _y + "\n";
			out += "\t" + _width+"\n";
			out += "\t" + _height+"\n";
			return out;
		}
		
		public function get consoleX():Number {
			return _x.value;
		}
		public function set consoleX(n:Number):void {
			_x.value = n;
		}
		public function get consoleY():Number {
			return _y.value;
		}
		public function set consoleY(n:Number):void {
			_y.value = n;
		}
		public function get consoleWidth():Number {
			return _width.value;
		}
		public function set consoleWidth(n:Number):void {
			_width.value = n;
		}
		public function get consoleHeight():Number {
			return _height.value;
		}
		public function set consoleHeight(n:Number):void {
			_height.value = n;
		}
		
		public function get rect():Rectangle 
		{
			return new Rectangle(consoleX, consoleY, consoleWidth, consoleHeight);
		}
		public function PersistenceManager(console:DConsole) 
		{
			_console = console;
			_persistenceDataSO = SharedObject.getLocal("consoleHistory");
			verticalSplitRatio = new PersistentProperty(_persistenceDataSO, "verticalSplitRatio", .25);
			dockState = new PersistentProperty(_persistenceDataSO, "dockState", 0);
			previousCommands = new PersistentProperty(_persistenceDataSO, "previousCommands", []);
			_width = new PersistentProperty(_persistenceDataSO, "width", 800);
			_height = new PersistentProperty(_persistenceDataSO, "height", 13 * GUIUnits.SQUARE_UNIT);
			_x = new PersistentProperty(_persistenceDataSO, "xPosition", 0);
			_y = new PersistentProperty(_persistenceDataSO, "yPosition", 0);
			_commandIndex = previousCommands.value.length;
			//trace("Initial persistence values: " + this);
		}
		public function clearHistory():void
		{
			previousCommands.returnToDefault();
		}
		public function clearAll():void {
			_x.returnToDefault();
			_y.returnToDefault();
			previousCommands.returnToDefault();
			dockState.returnToDefault();
			verticalSplitRatio.returnToDefault();
			_width.returnToDefault();
			_height.returnToDefault();
			_commandIndex = 0;
		}
		
		
		
		public function historyUp():String {
			var a:Array = previousCommands.value;
			if(a.length>0){
				_commandIndex = Math.max(_commandIndex-=1,0);
				return a[_commandIndex];
			}
			return "";
		}
		public function historyDown():String {
			var a:Array = previousCommands.value;
			if(_commandIndex<a.length-1){
				_commandIndex = Math.min(_commandIndex += 1, a.length - 1);
				return a[_commandIndex];
			}
			_commandIndex = a.length;
			return "";
		}
		public function addtoHistory(cmdStr:String):Boolean {
			var a:Array = previousCommands.value;
			if (a[a.length - 1] != cmdStr) {
				a.push(cmdStr);
				if (a.length > MAX_HISTORY) {
					a.shift();
				}
			}
			_commandIndex = a.length;
			return true;
		}
		
	}

}
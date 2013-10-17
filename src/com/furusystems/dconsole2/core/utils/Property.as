package com.furusystems.dconsole2.core.utils 
{
	public class Property 
	{
		private var _previousValue:* = null;
		public function Property(value:* = null) {
			_value = _previousValue = value;
		}
		private var _value:* = null;
		private var _dirty:Boolean = false;
		public function get value():* 
		{
			return _value;
		}		
		public function set value(value:*):void 
		{
			_value = value;
			_dirty = _value != _previousValue;
		}
		
		public function get dirty():Boolean 
		{
			return _dirty;
		}
		public function setClean():void {
			_previousValue = _value;
			_dirty = false;
		}
		public function revert():void {
			_value = _previousValue;
			_dirty = false;
		}
		public function toString():String {
			return "" + value + " (prev '" + _previousValue + "')";
		}
		public function dispose():void {
			_value = _previousValue = null;
		}
		
		
	}
	
}
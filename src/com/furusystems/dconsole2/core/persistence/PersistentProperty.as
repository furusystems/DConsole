package com.furusystems.dconsole2.core.persistence {
	import com.furusystems.dconsole2.core.utils.Property;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	public class PersistentProperty extends Property {
		private var _sharedObject:SharedObject;
		private var _fieldName:String;
		private var _initValue:*;
		private var _synced:Boolean = false;
		
		public function PersistentProperty(sharedObject:SharedObject, fieldName:String, initValue:* = null) {
			super(initValue);
			_initValue = initValue;
			_fieldName = fieldName;
			_sharedObject = sharedObject;
		}
		
		public function returnToDefault():void {
			value = _initValue;
		}
		
		override public function get value():* {
			if (!_synced) {
				consolidate();
			}
			return _sharedObject.data[_fieldName];
		}
		
		override public function set value(value:*):void {
			if (!_synced) {
				consolidate();
			}
			super.value = value;
			_sharedObject.data[_fieldName] = super.value;
		}
		
		override public function toString():String {
			return _fieldName + " : " + super.toString();
		}
		
		private function consolidate():void {
			if (_fieldName in _sharedObject.data) {
				super.value = _sharedObject.data[_fieldName];
			} else {
				super.value = _initValue;
				_sharedObject.data[_fieldName] = _initValue;
			}
			setClean();
			_synced = true;
		}
	
	}

}
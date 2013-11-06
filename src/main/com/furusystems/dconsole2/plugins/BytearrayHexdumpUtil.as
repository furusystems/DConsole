package com.furusystems.dconsole2.plugins {
	import com.furusystems.messaging.pimp.Message;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.utils.ByteArray;
	
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	
	public class BytearrayHexdumpUtil implements IDConsolePlugin {
		public static var useUpperCase:Boolean = false;
		
		private var chars:Array;
		
		public function dumpByteArray(byteArray:ByteArray, startIndex:uint = 0, endIndex:int = -1, tab:String = ""):String {
			var i:int, j:int, len:int = byteArray.length;
			var line:String, result:String;
			var byte:uint;
			
			if (endIndex == -1 || endIndex > len) {
				endIndex = len;
			}
			
			if ((startIndex < 0) || (startIndex > len)) {
				throw new RangeError("Start Index Is Out of Bounds: " + startIndex + "/" + len);
			}
			
			if ((endIndex < 0) || (endIndex > len) || (endIndex < startIndex)) {
				throw new RangeError("End Index Is Out of Bounds: " + endIndex + "/" + len);
			}
			
			j = 1;
			result = line = "";
			
			for (i = startIndex; i < endIndex; i++) {
				
				if (j == 1) {
					line += tab + padLeft(i.toString(16), 8, "0") + "  ";
					chars = [];
				}
				
				byte = byteArray[i];
				chars.push(byte);
				line += padLeft(byte.toString(16), 2, "0") + " ";
				
				if ((j % 4) == 0) {
					line += " ";
				}
				
				j++;
				
				if (j == 17) {
					line += dumpChars();
					result += (line + "\n");
					j = 1;
					line = "";
				}
			}
			
			if (j != 1) {
				line = padRight(line, 61, " ") + " " + dumpChars();
				result += line + "\n";
			}
			
			result = result.substr(0, result.length - 1);
			
			return useUpperCase ? result.toLocaleUpperCase() : result;
		}
		
		private function dumpChars():String {
			var byte:uint;
			var result:String = "";
			while (chars.length) {
				byte = chars.shift();
				if (byte >= 32 && byte <= 126) { // Only show printable characters
					result += String.fromCharCode(byte);
				} else {
					result += ".";
				}
			}
			return result;
		}
		
		private function padLeft(value:String, digits:uint, pad:String):String {
			return new Array(digits - value.length + 1).join(pad) + value;
		}
		
		private function padRight(value:String, digits:uint, pad:String):String {
			return value + (new Array(digits - value.length + 1).join(pad));
		}
		private var _hexDumpPos:uint;
		private var _scopeManager:ScopeManager;
		
		public function hexDump(startIndex:String = "", len:String = ""):String {
			var _startIndex:int, _endIndex:int, _len:int;
			var b:ByteArray = _scopeManager.currentScope.targetObject as ByteArray;
			var result:String;
			
			if (b) {
				try {
					_startIndex = ((startIndex == "") ? _hexDumpPos : parseInt(startIndex));
					_len = ((len == "") ? -1 : parseInt(len));
					
					if (isNaN(_startIndex) || isNaN(_len)) {
						throw new Error();
					}
					_endIndex = (_len == -1) ? (_startIndex + 160) : (_startIndex + _len);
					result = dumpByteArray(b, _startIndex, _endIndex);
					_hexDumpPos = _endIndex;
				} catch (e:Error) {
					//trace(e);
					throw new Error("Parameters are invalid");
				}
				
				return result;
			} else {
				throw new Error("Current scope is not a byte array");
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void {
			_scopeManager = pm.scopeManager;
			pm.console.createCommand("hexDump", hexDump, "HexUtil", "(if the current scope is a byte array) outputs the scope in paged hexadecimal view ");
			pm.messaging.addCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChange);
		}
		
		private function onScopeChange(md:MessageData):void {
			_hexDumpPos = 0;
		}
		
		public function shutdown(pm:PluginManager):void {
			pm.messaging.removeCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChange);
			_scopeManager = null;
			pm.console.removeCommand("hexDump");
		}
		
		public function get descriptionText():String {
			return "Enables the reading of ByteArrays as paged, tabulated hexadecimal";
		}
		
		public function get dependencies():Vector.<Class> {
			return null;
		}
	}
}
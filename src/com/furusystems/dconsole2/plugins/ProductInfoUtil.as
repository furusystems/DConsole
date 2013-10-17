package com.furusystems.dconsole2.plugins
{
	import com.furusystems.dconsole2.IConsole;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	
	/**
	 * Parse the ProductInfo tag from the root object's SWF.
	 * 
	 * c.f. http://wahlers.com.br/claus/blog/undocumented-swf-tags-written-by-mxmlc/
	 *
	 */
	public class ProductInfoUtil implements IDConsolePlugin
	{

		private var _root:DisplayObject;
		private var _isParsed:Boolean = false;
		private var _tagData:ByteArray;
		private var _console:IConsole;
				
				
		public function ProductInfoUtil()
		{
		}
		
		public function set root(value:DisplayObject):void {
			if (_root) {
				_isParsed = false;
				_tagData = null;
			}
			_root = value;	
			parseBytes();		
		}
		
		public function get root():DisplayObject {
			return _root;
		}
			
		public function get available():Boolean {
			return _isParsed && _tagData;
		}	
			
		public function get productID():uint {
			if (!available) { return NaN; }
			_tagData.position = 0;
			return _tagData.readUnsignedInt();
		}	
				
		public function get edition():uint {
			if (!available) { return NaN; }
			_tagData.position = 4;
			return _tagData.readUnsignedInt();
		}		
		
		public function get sdkVersion():String {
			if (!available) { return ""; }
			_tagData.position = 8;
			var major:uint, minor:uint, build:Number;
			major = _tagData.readUnsignedByte();
			minor = _tagData.readUnsignedByte();
			build = Number(_tagData.readUnsignedInt() +
			_tagData.readUnsignedInt() * (uint.MAX_VALUE + 1));
			return major + '.' + minor + '.0.' + build;
		}
		
		public function get compilationDate():Date {
			if (!available) { return null; }
			 var date:Date = new Date();
			_tagData.position = 18;
			date.time = Number(_tagData.readUnsignedInt() +
			_tagData.readUnsignedInt() * (uint.MAX_VALUE + 1));
			return date;
		}
		
		private function parseBytes():void {
			
			var loaderInfo:LoaderInfo;
			var bytes:ByteArray;
			var ub:uint = 5, sb:uint, frameRectSize:uint;
			var packedTag:uint, code:uint, len:uint;

			_isParsed = true;
			
			try {
				loaderInfo = _root.loaderInfo;
				bytes = loaderInfo.bytes;
			}
			catch(e:Error) {	
				return;
			}
	
			bytes.endian = Endian.LITTLE_ENDIAN;

			// Skip the header
			bytes.position = 8;
			
			// Read the size of and skip the frame rectangle
			sb = bytes.readUnsignedByte() >> (8 - ub);
			frameRectSize = Math.ceil((ub + (sb * 4)) / 8);
			bytes.position += (frameRectSize - 1);

			// Skip the frame rate and frame count
			bytes.position += 4;			
			
			// Search for the productInfo tag
			while(bytes.bytesAvailable) {
				packedTag = bytes.readUnsignedShort();
				code = packedTag >> 6;
				len = packedTag & 0x3f;
				if (len == 0x3f) {
					len = bytes.readInt();
				}
				if (code == 0x29) {	// ProductInfo tag
					_tagData = new ByteArray();
					_tagData.endian = Endian.LITTLE_ENDIAN;
					bytes.readBytes(_tagData, 0, len);
					_isParsed = true;
					return;
				}
				bytes.position += len;
			}
			
			// SWFs without productInfo tags will reach here without
			// having set the _tagData property.  This is okay.
		}
		
		
		public function getProductInfo():void
		{
			root = _console.view.root;
			_console.print("Product info:", ConsoleMessageTypes.SYSTEM);
			if (available) {
				_console.print(" ProductID : " + productID);
				_console.print(" Edition : " + edition);
				_console.print(" Version : " + sdkVersion);
				_console.print(" Compilation Date : " + compilationDate);
			}
			else {
				_console.print(" Product info not available for this SWF (tag not found).");
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void
		{
			_console = pm.console;
			_console.createCommand("productInfo", getProductInfo, "ProductInfoUtil", "Displays the contents of Flex ProductInfo tag (Flex SWFs only)");
		}
		
		public function shutdown(pm:PluginManager):void
		{
			_console.removeCommand("productInfo");
		}
		
		public function get descriptionText():String
		{
			return "Displays the contents of Flex ProductInfo tag (Flex SWFs only)";
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}

	}
}
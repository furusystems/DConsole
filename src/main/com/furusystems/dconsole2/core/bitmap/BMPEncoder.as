package com.furusystems.dconsole2.core.bitmap {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class BMPEncoder {
		public function BMPEncoder() {
		}
		
		public static function encode(data:BitmapData):ByteArray {
			var values:Vector.<uint> = data.getVector(data.rect);
			
			var bitsPerPixel:int = 24;
			var w:int = data.width;
			var h:int = data.height;
			var rowSize:int = Math.ceil((bitsPerPixel * w) / 32) * 4;
			var padding:int = rowSize - bitsPerPixel / 8 * w;
			var arraySize:int = rowSize * h;
			
			//var offset:uint = 21;
			var offset:uint = 54;
			var size:uint = offset + arraySize;
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeByte(0x42);
			bytes.writeByte(0x4D);
			bytes.writeUnsignedInt(size);
			bytes.writeUnsignedInt(0);
			bytes.writeUnsignedInt(offset);
			
			/*
			   // BITMAPCOREHEADER
			   bytes.writeByte(12);
			   bytes.writeShort(w);
			   bytes.writeShort(h);
			   bytes.writeByte(1);
			   bytes.writeByte(bitsPerPixel);
			 */
			
			// BITMAPINFOHEADER
			bytes.writeUnsignedInt(40);
			bytes.writeInt(w);
			bytes.writeInt(h);
			bytes.writeShort(1);
			bytes.writeShort(bitsPerPixel);
			bytes.writeUnsignedInt(0);
			bytes.writeUnsignedInt(arraySize);
			bytes.writeUnsignedInt(0x0B13);
			bytes.writeUnsignedInt(0x0B13);
			bytes.writeUnsignedInt(0);
			bytes.writeUnsignedInt(0);
			
			for (var y:int = h - 1; y >= 0; y--) {
				for (var x:int = 0; x < w; x++) {
					var value:uint = values[x + y * w];
					bytes.writeByte(value & 0xFF);
					bytes.writeByte((value >> 8) & 0xFF);
					bytes.writeByte((value >> 16) & 0xFF);
				}
				for (var i:int = 0; i < padding; i++) {
					bytes.writeByte(0);
				}
			}
			
			return bytes;
		}
	
	}

}
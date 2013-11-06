package com.furusystems.dconsole2.core.io {
	import flash.errors.IOError;
	
	/**
	 * Class Reader
	 * 	Mimics the java.io.Reader
	 *
	 * @author Cristobal Dabed
	 * @version 0.2
	 */
	public class Reader implements ICloseable, IReadable {
		// TODO: Test performance on wether to have stream as Vector.<int> instead of an String only
		
		// NOTE: The mark & markSupported methods are not added since we only work with String stream @see http://download.oracle.com/javase/6/docs/api/java/io/StringReader.html#mark(int)
		//       We don't actually work with a File this would be the case when using Air or neeeded to add other similar InputStream classes
		
		private var _stream:String;
		private var _position:int = -1;
		private var _locked:Boolean = false;
		private var _ready:Boolean = false;
		
		public function Reader() {
			// Abstract Class
		
		}
		
		/**
		 * Get the current position in the stream
		 *
		 * @return
		 * 	The current position, position is zero-indexed
		 */
		public function position():int {
			return _position;
		}
		
		/**
		 * Set position
		 *
		 * @param value
		 */
		private function setPosition(value:int):void {
			_position = value;
		}
		
		/**
		 * Close the stream
		 */
		public function close():void {
			_stream = null;
			setPosition(-1);
			setReady(false);
		}
		
		/**
		 * Reads a single character.
		 *
		 * @return
		 * 	The character read, as an integer in the range 0 to 65535 (0x00-0xffff), or -1 if the end of the stream has been reached
		 */
		public function read():int {
			enforceStream();
			
			// We work directly on _stream + _position params to max speed
			// avoiding function calls here
			var char:int = -1;
			if (_position < _stream.length) {
				char = _stream.charCodeAt(_position);
				_position++;
			}
			return char;
		}
		
		/**
		 * Get the reader stream
		 *
		 * @return
		 * 	Returns a copy of the current reader stream
		 */
		public function stream():String {
			return _stream;
		}
		
		/**
		 * Set stream
		 *
		 * @param value
		 */
		protected function setStream(value:String):void {
			/*
			   if(!value){
			   throw new IOError("Reader :: invalid stream");
			   }
			 */
			_stream = value;
			setPosition(0);
			setReady(true);
		}
		
		/**
		 * Throws an error if no stream is available in the Reader
		 */
		private function enforceStream():void {
			if (!_stream) {
				throw new IOError("Reader :: No Stream");
			}
		}
		
		/**
		 * Tells wether this stream is ready to be read.
		 */
		public function ready():Boolean {
			return _ready;
		}
		
		/**
		 * Set ready
		 *
		 * @param value
		 */
		private function setReady(value:Boolean):void {
			_ready = value;
		}
		
		/**
		 * Tells wether this stream is locked or not
		 */
		public function locked():Boolean {
			return _locked;
		}
		
		/**
		 * Lock the stream
		 */
		protected function lock():void {
			_locked = true;
		}
		
		/**
		 * Unlock the stream
		 */
		protected function unlock():void {
			_locked = false;
		}
		
		/**
		 * Resets the stream. If the stream has been marked, then attempt to reposition it at the mark. If the stream has not been marked,
		 * then attempt to reset it in some way appropriate to the particular stream, for example by repositioning it to its starting point.
		 */
		public function reset():void {
			enforceStream();
			
			setPosition(0);
			setReady(false);
		}
		
		/**
		 * Skips the specified number of characters in the stream.
		 *
		 * @param n	The number of characters to skip
		 * @return
		 * 		The number of characters actually skipped
		 */
		public function skip(n:Number):Number {
			enforceStream();
			
			/* Skip value can not be negative */
			if (n < 0) {
				throw new ArgumentError("skip value is negative");
			}
			
			/*
			   As long as the current position + skip value is less than the length of the stream
			   n remains the same
			
			   Otherwise `n = stream.length() - position - 1`
			 */
			if ((_position + n) < _stream.length) {
				_position += n;
			} else {
				n = _stream.length - _position - 1;
				_position = _stream.length - 1; // set the position to the end
			}
			return n;
		}
	
	}
}
package com.furusystems.dconsole2.core.io {
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * FileReader.as
	 *
	 * 	mimics the java.io.FileReader class
	 *
	 * @author Cristobal Dabed
	 * @version 0.1
	 */
	public final class FileReader extends Reader {
		private var _error:Error;
		
		/**
		 * Constructor
		 *
		 * @param filename The filename to load
		 */
		public function FileReader(filename:String) {
			super();
			load(filename);
		}
		
		// == Properties
		
		/**
		 * @readonly error
		 */
		public function get error():Error {
			return _error;
		}
		
		// == Methods
		
		/**
		 * Load file
		 *
		 */
		private function load(filename:String):void {
			/* lock */
			lock();
			
			/* Setup loader */
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorEvent);
			
			/* Load File */
			loader.load(new URLRequest(filename));
		}
		
		/**
		 * Set Error
		 *
		 * @param error
		 */
		private function setError(value:Error):void {
			_error = value;
		}
		
		// == Loader Events
		
		/**
		 * On complete
		 *
		 * @param event The flash event
		 */
		private function onComplete(event:Event):void {
			// event.target.data pass data to reader for processing
			setStream(event.target.data);
			unlock();
		}
		
		/**
		 * On io error
		 *
		 * @param error The IO error
		 */
		private function onIOError(ioError:IOError):void {
			setError(ioError);
			unlock();
		}
		
		/**
		 * On security error
		 *
		 * @param error The security error
		 */
		private function onSecurityErrorEvent(securityError:SecurityErrorEvent):void {
			setError(new Error(securityError.toString()));
			unlock();
		}
	}
}
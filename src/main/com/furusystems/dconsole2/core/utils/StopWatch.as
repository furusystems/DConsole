package com.furusystems.dconsole2.core.utils {
	import flash.utils.getTimer;
	
	/**
	 * Stop watch
	 *
	 * @author Cristobal Dabed
	 */
	public final class StopWatch {
		private var _startTime:int = 0;
		private var _stopTime:int = 0;
		private var _running:Boolean = false;
		
		public function StopWatch() {
		}
		
		/**
		 * Start
		 *
		 * @param reset Optional reset flag, wether to reset the timer on start.
		 */
		public function start(reset:Boolean = false):void {
			if (reset) {
				this.reset();
			}
			_startTime = getTimer();
			_running = true;
		}
		
		/**
		 * Stop
		 */
		public function stop():void {
			_stopTime = getTimer();
			_running = false;
		}
		
		/**
		 * Reset
		 */
		public function reset():void {
			_startTime = 0;
			_stopTime = 0;
			_running = false;
		}
		
		/**
		 * @readonly startTime
		 */
		public function get startTime():int {
			return _startTime;
		}
		
		/**
		 * @readonly stopTime
		 */
		public function get stopTime():int {
			return _stopTime;
		}
		
		/**
		 * @readonly elapsedTime
		 */
		public function get elapsedTime():int {
			var value:int = stopTime - startTime;
			if (_running) {
				value = getTimer() - startTime;
			}
			return value;
		}
		
		/**
		 * @readonly elapsedTimeSeconds
		 */
		public function get elapsedTimeSeconds():Number {
			return elapsedTime / 1000;
		}
	}
}
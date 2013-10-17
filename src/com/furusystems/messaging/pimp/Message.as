package com.furusystems.messaging.pimp {
	
	/**
	 * Basic marker Message type. May be swapped out for string or int pointers later
	 * if we don't wind up adding any properties to it.
	 * @author Andreas Rønning
	 */
	public class Message {
		private static var idPool:uint = 0;
		public var id:int = idPool++;
	}

}
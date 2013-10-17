package com.furusystems.dconsole2.core.io {
	
	/**
	 * StringReader
	 *
	 * 	mimics the java.io.StringReader class
	 *
	 * @author Cristobal Dabed
	 * @version 0.1
	 */
	public final class StringReader extends Reader {
		/**
		 * Constructor
		 *
		 * @param s String providing the character stream.
		 */
		public function StringReader(s:String) {
			super();
			setStream(s);
		}
	}
}
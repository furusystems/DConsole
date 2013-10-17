package com.furusystems.dconsole2.core.strings {
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class AssistantStringCollection extends StringCollection {
		[Embed(source='AssistantStrings.xml',mimeType='application/octet-stream')]
		private var StringXML:Class;
		
		public function AssistantStringCollection() {
			populate(XML(new StringXML()));
		}
		
		public const SCALE_HANDLE_ID:String = "scalehandle";
		public const CORNER_HANDLE_ID:String = "cornerhandle";
		public const HEADER_BAR_ID:String = "headerbar";
		public const DEFAULT_ID:String = "default";
	
	}

}
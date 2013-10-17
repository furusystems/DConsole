package com.furusystems.dconsole2.core.style.fonts {
	import flash.text.Font;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class Fonts {
		
		[Embed(source="cft.ttf",fontName="CodingFontTobi",embedAsCFF="false",unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+00C0-U+00D6,U+00D8-U+00F8",mimeType="application/x-font-truetype")]
		private static var CodingFontTobi:Class;
		public static const codingFontTobi:Font = new CodingFontTobi();
	
	}

}
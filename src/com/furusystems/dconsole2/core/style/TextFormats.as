package com.furusystems.dconsole2.core.style {
	import com.furusystems.dconsole2.core.style.fonts.Fonts;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public final class TextFormats {
		public static const OUTPUT_SIZE:Number = 16;
		public static const GUI_SIZE:Number = 16;
		public static const OUTPUT_LEADING:Number = 0;
		public static const OUTPUT_FONT:String = Fonts.codingFontTobi.fontName;
		//public static const OUTPUT_FONT:String = "_typewriter";
		public static const GUI_FONT:String = Fonts.codingFontTobi.fontName;
		//public static const INPUT_FONT:String = "_typewriter";
		public static const INPUT_FONT:String = Fonts.codingFontTobi.fontName;
		public static const INPUT_SIZE:Number = 16;
		
		public static const inputTformat:TextFormat = makeFormat(INPUT_FONT, INPUT_SIZE, TextColors.TEXT_INPUT);
		public static const helpTformat:TextFormat = makeFormat(INPUT_FONT, INPUT_SIZE, TextColors.TEXT_ASSISTANT);
		
		public static const outputTformatUser:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_USER);
		public static const outputTformatLineNo:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_AUX);
		public static const outputTformatOld:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_DEBUG);
		public static const outputTformatHidden:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, BaseColors.BLACK);
		public static const outputTformatTag:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_TAG);
		public static const outputTformatNew:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_INFO);
		public static const hoorayFormat:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_DEBUG);
		public static const outputTformatSystem:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_SYSTEM);
		public static const outputTformatTimeStamp:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_AUX);
		public static const outputTformatDebug:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_DEBUG);
		public static const outputTformatWarning:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_WARNING);
		public static const outputTformatError:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_ERROR);
		public static const outputTformatFatal:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_FATAL);
		public static const outputTformatInfo:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_INFO);
		public static const outputTformatAux:TextFormat = makeFormat(OUTPUT_FONT, OUTPUT_SIZE, TextColors.TEXT_AUX);
		//TODO: Running out of colors here. Need to take another gander at these
		public static const consoleTitleFormat:TextFormat = makeFormat(GUI_FONT, GUI_SIZE, BaseColors.WHITE);
		public static const windowDefaultFormat:TextFormat = makeFormat(GUI_FONT, GUI_SIZE, BaseColors.WHITE);
		
		/**
		 * Returns a textformat copy with inverted color
		 * @param	tformat
		 * @return
		 */
		public static function getInverse(tformat:TextFormat):TextFormat {
			var newFormat:TextFormat = new TextFormat(tformat.font, tformat.size, tformat.color, tformat.bold, tformat.italic, tformat.underline, tformat.url, tformat.target, tformat.align, tformat.leftMargin, tformat.rightMargin, tformat.indent, tformat.leading);
			newFormat.color = BaseColors.WHITE - uint(tformat.color);
			return newFormat;
		}
		
		private static function makeFormat(font:String, size:int, color:uint):TextFormat {
			return new TextFormat(font, size, color, null, null, null, null, null, null, 0, 0, 0, 0);
		}
		
		public static function refresh():void {
			inputTformat.color = TextColors.TEXT_INPUT;
			helpTformat.color = TextColors.TEXT_ASSISTANT;
			outputTformatUser.color = TextColors.TEXT_USER;
			outputTformatLineNo.color = TextColors.TEXT_AUX;
			outputTformatOld.color = TextColors.TEXT_DEBUG;
			outputTformatHidden.color = BaseColors.BLACK;
			outputTformatTag.color = TextColors.TEXT_TAG;
			outputTformatNew.color = TextColors.TEXT_INFO;
			hoorayFormat.color = TextColors.TEXT_DEBUG;
			outputTformatSystem.color = TextColors.TEXT_SYSTEM;
			outputTformatInfo.color = TextColors.TEXT_INFO;
			outputTformatAux.color = TextColors.TEXT_AUX;
			
			outputTformatTimeStamp.color = TextColors.TEXT_AUX;
			outputTformatDebug.color = TextColors.TEXT_DEBUG;
			outputTformatWarning.color = TextColors.TEXT_WARNING;
			outputTformatError.color = TextColors.TEXT_ERROR;
			outputTformatFatal.color = TextColors.TEXT_FATAL;
			consoleTitleFormat.color = BaseColors.WHITE;
			windowDefaultFormat.color = BaseColors.BLACK;
		
			//trace("Text color: " + outputTformatTag.color.toString(16));
		}
	
	}

}
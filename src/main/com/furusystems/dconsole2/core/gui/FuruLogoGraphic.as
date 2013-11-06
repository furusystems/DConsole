package com.furusystems.dconsole2.core.gui {
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class FuruLogoGraphic extends Sprite {
		[Embed(source='assets/furulogo.swf',mimeType='application/octet-stream')]
		private var _sourceSWF:Class;
		
		public function FuruLogoGraphic() {
			var bytes:ByteArray = ByteArray(new _sourceSWF());
			var l:Loader = new Loader();
			addChild(l);
			l.scaleX = l.scaleY = .3;
			l.loadBytes(bytes);
		}
	
	}

}
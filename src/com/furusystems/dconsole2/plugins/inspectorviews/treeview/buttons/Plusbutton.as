package com.furusystems.dconsole2.plugins.inspectorviews.treeview.buttons 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.furusystems.dconsole2.core.gui.AbstractButton;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class Plusbutton extends AbstractButton
	{
		[Embed(source='../assets/plusbutton.png')]
		private static var BitmapClass:Class;
		private static const ICON:BitmapData = Bitmap(new BitmapClass()).bitmapData;
		public function Plusbutton() 
		{
			super(ICON.width, ICON.height);
			setIcon(ICON);
			active = true;
		}
		
	}

}
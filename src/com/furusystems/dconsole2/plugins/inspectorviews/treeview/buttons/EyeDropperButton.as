package com.furusystems.dconsole2.plugins.inspectorviews.treeview.buttons 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.furusystems.dconsole2.core.gui.AbstractButton;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class EyeDropperButton extends AbstractButton
	{
		[Embed(source='../assets/eyeDropper.png')]
		private static var bitmap:Class;
		private static const ICON:BitmapData = Bitmap(new bitmap()).bitmapData;
		public function EyeDropperButton()
		{
			super(ICON.width, ICON.height);
			setIcon(ICON);
			updateAppearance();
			_toggleSwitch = true;
		}
		
	}

}
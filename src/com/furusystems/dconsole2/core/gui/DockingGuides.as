package com.furusystems.dconsole2.core.gui {
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.BaseColors;
	import com.furusystems.messaging.pimp.IMessageReceiver;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class DockingGuides extends Shape implements IMessageReceiver {
		public static const TOP:int = 0;
		public static const BOT:int = 1;
		
		public function DockingGuides() {
			//blendMode = BlendMode.INVERT;
			PimpCentral.addReceiver(this, Notifications.SHOW_DOCKING_GUIDE, Notifications.HIDE_DOCKING_GUIDE);
			visible = false;
		}
		
		public function resize():void {
			graphics.clear();
			graphics.lineStyle(3, BaseColors.ORANGE);
			graphics.lineTo(stage.stageWidth, 0);
		}
		
		public function show(position:int):void {
			switch (position) {
				case TOP:
					y = 0;
					break;
				case BOT:
					y = stage.stageHeight - 1;
					break;
			}
			visible = true;
		}
		
		public function hide():void {
			visible = false;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.notification.IMessageReceiver */
		
		public function onMessage(d:MessageData):void {
			switch (d.message) {
				case Notifications.SHOW_DOCKING_GUIDE:
					show(d.data as int);
					break;
				case Notifications.HIDE_DOCKING_GUIDE:
					hide();
					break;
			}
		}
	
	}

}
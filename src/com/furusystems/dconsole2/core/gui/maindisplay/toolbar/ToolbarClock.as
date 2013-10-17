package com.furusystems.dconsole2.core.gui.maindisplay.toolbar {
	import com.furusystems.dconsole2.core.gui.TextFieldFactory;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.style.Colors;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ToolbarClock extends Sprite {
		private var _tf:TextField;
		private var _mouseOver:Boolean;
		
		public function ToolbarClock(messaging:PimpCentral) {
			_tf = TextFieldFactory.getLabel("test");
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.textColor = Colors.HEADER_FG;
			
			_tf.mouseEnabled = false;
			addChild(_tf);
			messaging.addCallback(Notifications.FRAME_UPDATE, updateClock);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOut(e:MouseEvent):void {
			_mouseOver = false;
		}
		
		private function onMouseOver(e:MouseEvent):void {
			_mouseOver = true;
		}
		
		public function setColor(color:uint):void {
			_tf.textColor = color;
		}
		
		public function updateClock(md:MessageData):void {
			if (_mouseOver) {
				_tf.text = new Date().toString();
				_tf.alpha = 1;
			} else {
				_tf.text = new Date().toTimeString();
				_tf.alpha = 0.5;
			}
			_tf.x = -_tf.width - 10;
		}
	
	}

}
package com.furusystems.dconsole2.core.helpmanager {
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class HelpManager {
		private var topics:Dictionary = new Dictionary();
		
		public function HelpManager(messaging:PimpCentral) {
			messaging.addCallback(Notifications.HELP_TOPIC_ADD_REQUEST, onHelpAddRequest);
			messaging.addCallback(Notifications.HELP_TOPIC_REMOVE_REQUEST, onHelpRemoveRequest);
		}
		
		private function onHelpRemoveRequest(md:MessageData):void {
			delete(topics[md.data.title.toLowerCase()]);
		}
		
		private function onHelpAddRequest(md:MessageData):void {
			topics[md.data.title.toLowerCase()] = md.data;
		}
		
		public function addTopic(title:String, content:String):void {
			topics[title.toLowerCase()] = new HelpTopic(title, content);
		}
		
		public function getTopic(topic:String):String {
			if (topics[topic.toLowerCase()] != null) {
				return HelpTopic(topics[topic.toLowerCase()]).toString();
			} else {
				return "No such topic '" + topic + "'";
			}
		}
		
		public function getToc():String {
			var out:String = "Table of contents:\n";
			var sorted:Array = [];
			for (var title:String in topics) {
				sorted.push(topics[title]);
			}
			sorted.sortOn("title");
			for (var i:int = sorted.length; i--; ) {
				out += "\t" + sorted[i].title;
			}
			return out;
		}
	
	}

}
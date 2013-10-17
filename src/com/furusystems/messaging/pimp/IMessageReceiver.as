package com.furusystems.messaging.pimp {
	
	/**
	 * Describes a message receiver that can add itself to PimpCentral as a listener for a specific message type
	 */
	public interface IMessageReceiver {
		/**
		 * Called by PimpCentral when the message is dispatched
		 * @param	messageData
		 * data object containing message details
		 */
		function onMessage(messageData:MessageData):void;
	}
}
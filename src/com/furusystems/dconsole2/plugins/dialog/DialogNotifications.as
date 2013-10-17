package com.furusystems.dconsole2.plugins.dialog 
{
	import com.furusystems.messaging.pimp.Message;
	public class DialogNotifications 
	{
		static public const ABORT_DIALOG:Message = new Message();
		static public const START_DIALOG:Message = new Message();
		static public const DIALOG_COMPLETE:Message = new Message();
	}

}
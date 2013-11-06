package com.furusystems.dconsole2.plugins.mediatester
{
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class NetStatusEventCodes 
	{
		public static const BUFFER_EMPTY:String = "NetStream.Buffer.Empty";
		public static const BUFFER_FULL:String = "NetStream.Buffer.Full";
		public static const BUFFER_FLUSH:String = "NetStream.Buffer.Flush";
		public static const PLAY_START:String = "NetStream.Play.Start";
		public static const PLAY_STOP:String = "NetStream.Play.Stop";
		public static const PLAY_FAILED:String = "NetStream.Play.Failed";
		public static const PLAY_STREAM_NOT_FOUND:String = "NetStream.Play.StreamNotFound";
		public static const PAUSE_NOTIFY:String = "NetStream.Pause.Notify";
		public static const UNPAUSE_NOTIFY:String = "NetStream.Unpause.Notify";
		public static const SEEK_NOTIFY:String = "NetStream.Seek.Notify";
		
	}
	
}
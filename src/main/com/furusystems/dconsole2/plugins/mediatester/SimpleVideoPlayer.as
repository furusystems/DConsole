package com.furusystems.dconsole2.plugins.mediatester 
{
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import com.furusystems.dconsole2.core.gui.Window;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class SimpleVideoPlayer extends Window
	{
		private var _contents:Sprite = new Sprite;
		private var _manager:MediaTesterUtil;
		private var nc:NetConnection;
		private var ns:NetStream;
		private var _mediaURI:String;
		private var _applicationURI:String;
		private var _video:Video;
		private var _firstPlay:Boolean = true;
		
		public function SimpleVideoPlayer(manager:MediaTesterUtil,mediaURI:String,applicationURI:String = "") 
		{
			super(mediaURI, new Rectangle(0, 0, 100, 80), _contents, null, null, true, false);
			_contents.buttonMode = true;
			_manager = manager;
			_mediaURI = mediaURI;
			_applicationURI = applicationURI;
			nc = new NetConnection();
			nc.client = this;
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncerror, false, 0, true);
			nc.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
			switch(applicationURI) {
				case "":
				nc.connect(null);
				break;
				default:
				nc.connect(applicationURI);
			}
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			ns.client = this;
			_contents.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			_video = new Video();
			_contents.addChild(_video);
			_video.attachNetStream(ns);
			play();
		}
		
		private function onClick(e:MouseEvent):void 
		{
			play();
		}
		
		private function onNetStatus(e:NetStatusEvent):void 
		{
			switch(e.info.code) {
				case NetStatusEventCodes.PLAY_STREAM_NOT_FOUND:
				_manager.log("Stream not found");
				_manager.destroy(this);
				break;
			}
		}
		public function close():void {
			ns.close();
			nc.close();
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			_manager.log(e.text);
		}
		public function onMetaData(o:Object):void {
			if (!_firstPlay) return;
			_firstPlay = false;
			_video.width = o.width;
			_video.height = o.height;
			scaleToContents();
		}
		
		private function onAsyncerror(e:AsyncErrorEvent):void 
		{
			
		}
		protected function onXMPData(o:Object):void {
			
		}
		public function play():void {
			ns.play(_mediaURI);
		}
		override protected function onClose(e:MouseEvent):void 
		{
			_manager.destroy(this);
			super.onClose(e);
		}
		override protected function onResize():void 
		{
			_video.width = viewRect.width;
			_video.height= viewRect.height;
		}
		
	}

}
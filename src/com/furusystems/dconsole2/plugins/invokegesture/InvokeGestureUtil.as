package com.furusystems.dconsole2.plugins.invokegesture 
{
	import com.furusystems.dconsole2.IConsole;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	
	/**
	 * ...
	 * @author Andreas Ronning
	 */
	public class InvokeGestureUtil implements IDConsolePlugin 
	{
		private var _console:IConsole;
		private var _stage:Stage;
		private var _tl:Rectangle = new Rectangle(0, 0, 30, 30);
		private var _tr:Rectangle = new Rectangle(0, 0, 30, 30);
		private var _bl:Rectangle = new Rectangle(0, 0, 30, 30);
		private var _br:Rectangle = new Rectangle(0, 0, 30, 30);
		
		private var _rects:Vector.<Rectangle> = Vector.<Rectangle>([_tl, _tr, _br, _bl]);
		private var _sequence:Vector.<uint> = new Vector.<uint>();
		
		public function InvokeGestureUtil() 
		{
			
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function get descriptionText():String 
		{
			return "Enables a clockwise tap in each screen corner to show/hide the console";
		}
		
		public function initialize(pm:PluginManager):void 
		{
			pm.console.view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_console = pm.console;
			if (_console.view.stage) onAddedToStage(); 
		}
		
		private function onAddedToStage(e:Event = null):void 
		{
			_console.view.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_stage = _console.view.stage;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize();
			setupGesture();
		}
		
		public function shutdown(pm:PluginManager):void 
		{
			_stage.removeEventListener(Event.RESIZE, onStageResize);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_console = null;
			_stage = null;
		}
		
		private function setupGesture():void 
		{
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			var mp:Point = new Point(_stage.mouseX, _stage.mouseY);
			
			for each(var r:Rectangle in _rects) {
				if (r.containsPoint(mp)) {
					addToSequence(r);
					return;
				}
			}
		}
		private function addToSequence(r:Rectangle):void {
			if (_sequence.length > 4)_sequence.shift();
			switch(r) {
				case _tl:
					_sequence.push(0);
				break;
				case _tr:
					_sequence.push(1);
				break;
				case _br:
					_sequence.push(2);
				break;
				case _bl:
					_sequence.push(3);
				break;
			}
			evaluateSequence();
		}
		
		private function evaluateSequence():void 
		{
			var sequenceString:String = _sequence.join("");
			sequenceString = sequenceString + sequenceString; //full cycle
			if (sequenceString.indexOf("0123") > -1) {
				_console.toggleDisplay();
				_sequence = new Vector.<uint>();
			}
		}
		
		private function onStageResize(e:Event = null):void 
		{
			moveTapRects();
		}
		
		private function moveTapRects():void 
		{
			_tl.x = _tl.y = _tr.y = _bl.x = 0;
			_tr.x = _br.x = _stage.stageWidth - _tr.width;
			_bl.y = _br.y = _stage.stageHeight - _bl.height;
		}
		
				
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
		
	}

}
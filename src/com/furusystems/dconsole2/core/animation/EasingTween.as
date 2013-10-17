package com.furusystems.dconsole2.core.animation 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	/**
	 * A sinusoidally (whooee) easing tween
	 * @author Andreas Roenning
	 */
	public class EasingTween implements IConsoleTweenProcess
	{
		private static var frameSource:Shape = new Shape();
		private var _object:Object;
		private var _property:String;
		private var _targetValue:Number;
		private var _tweenTime:Number;
		private var _startTime:Number;
		private var _origValue:Number;
		private var _onComplete:Function;
		public function EasingTween(object:Object, property:String, targetValue:Number, tweenTime:Number,onComplete:Function) 
		{
			_onComplete = onComplete;
			_tweenTime = tweenTime;
			_targetValue = targetValue;
			_property = property;
			_object = object;
			_origValue = _object[_property];
			_startTime = getTimer();
			frameSource.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var elapsed:Number = (getTimer() - _startTime) * 0.001;
			var t:Number = elapsed / _tweenTime;
			_object[_property] = _origValue + (_targetValue-_origValue) * Math.sin(t * 1.55);
			if (elapsed >= _tweenTime) {
				stop();
				_object[_property] = _targetValue;
				_onComplete();
			}
		}
		public function stop():void {
			frameSource.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			ConsoleTweener.removeTween(this);
		}
		
		public function get object():Object { return _object; }
		
		public function set object(value:Object):void 
		{
			_object = value;
		}
		
	}

}
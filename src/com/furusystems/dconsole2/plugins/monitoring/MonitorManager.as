package com.furusystems.dconsole2.plugins.monitoring 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.DConsole;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class MonitorManager
	{
		
		private var monitors:Vector.<Monitor> = new Vector.<Monitor>();
		private var monitorTimer:Timer = new Timer(300);
		private var console:DConsole;
		private var scopeManager:ScopeManager;
		public function MonitorManager(console:DConsole,scopeMgr:ScopeManager)
		{
			this.console = console;
			this.scopeManager = scopeMgr;
			monitorTimer.addEventListener(TimerEvent.TIMER, update);
		}
		public function set interval(n:int):void {
			if (n < 1000/console.stage.frameRate) {
				n = 1000/console.stage.frameRate;
			}
			monitorTimer.delay = n;
		}
		public function get interval():int {
			return monitorTimer.delay;
		}
		public function start():void {
			monitorTimer.start();
		}
		public function stop():void {
			monitorTimer.stop();
		}
		public function addMonitor(scope:Object, ...properties:Array):Monitor {
			var m:Monitor;
			for (var i:int = 0; i < monitors.length; i++) 
			{
				if (monitors[i].scope == scope) {
					m = monitors[i];
					inner: for (var j:int = 0; j < properties.length; j++) 
					{
						for (var k:int = 0; k < monitors[i].properties.length; k++) 
						{
							if (properties[j] == monitors[i].properties[k]) continue inner;
						}
						monitors[i].properties.push(properties[j]);
					}
					console.print("Existing monitor found, appending properties", ConsoleMessageTypes.SYSTEM);
					m.update(true);
				}
			}
			if (!m) {
				m = new Monitor(this, scope, properties);
				monitors.push(m);
				//console.pluginContainer.addChild(m);
				console.print("New monitor created", ConsoleMessageTypes.SYSTEM);
			}
			return m;
			
		}
		public function removeMonitor(scope:Object):Boolean {
			for (var i:int = 0; i < monitors.length; i++) 
			{
				if (monitors[i].scope == scope) {
					//console.pluginContainer.removeChild(monitors[i]);
					monitors.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		private function update(e:TimerEvent = null):void {
			for (var i:int = 0; i < monitors.length; i++) 
			{
				monitors[i].update();
			}
		}
		
		public function destroyMonitors():void
		{
			var count:int = 0;
			for (var i:int = 0; i < monitors.length; i++) 
			{
				//console.pluginContainer.removeChild(monitors[i]);
				count++;
			}
			monitors = new Vector.<Monitor>;
			console.print(count+" monitors destroyed",ConsoleMessageTypes.SYSTEM);
		}
		
		public function destroyMonitor():void
		{
			if (removeMonitor(scopeManager.currentScope.targetObject)) {
				console.print("Removed", ConsoleMessageTypes.SYSTEM);
			}else {
				console.print("No such monitor", ConsoleMessageTypes.ERROR);
			}
		}
		
		public function createMonitor(...properties:Array):void
		{
			properties.unshift(scopeManager.currentScope.targetObject);
			addMonitor.apply(this, properties);
		}
		public function setMonitorInterval(i:int = 300):int {
			if (i < 0) i = 0;
			monitorTimer.delay = i;
			return monitorTimer.delay;
		}
		
	}

}
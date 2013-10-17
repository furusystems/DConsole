package com.furusystems.dconsole2.plugins.controller 
{
	import com.furusystems.dconsole2.core.commands.UnparsedCommand;
	import com.furusystems.dconsole2.core.introspection.ScopeManager;
	import com.furusystems.dconsole2.core.plugins.IUpdatingDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.DConsole;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class ControllerUtil extends Sprite implements IUpdatingDConsolePlugin
	{
		private var _controllers:Vector.<Controller> = new Vector.<Controller>;
		private var _scopeManager:ScopeManager;
		
		internal function addController(object:*, properties:Array,x:Number = 0,y:Number = 0):void {
			var c:Controller = new Controller(object, properties, this);
			c.x = Math.max(0, Math.min(x, stage.stageWidth - c.width));
			c.y = Math.max(0, Math.min(y, stage.stageHeight - c.height));
			_controllers.push(addChild(c) as Controller);
		}
		internal function removeController(c:Controller):void {
			for (var i:int = 0; i < _controllers.length; i++) 
			{
				if (_controllers[i] == c) {
					_controllers[i].destroy();
					_controllers.splice(i, 1);
					removeChild(c);
					break;
				}
			}
		}
		
		private function createController(...properties:Array):void
		{
			var x:Number = 0;
			var y:Number = 0;
			if (_scopeManager.currentScope.targetObject is DisplayObject) {
				var r:Rectangle = DisplayObject(_scopeManager.currentScope.targetObject).transform.pixelBounds;
				x = r.x + r.width;
				y = r.y + r.height;
			}
			addController(_scopeManager.currentScope.targetObject, properties, x, y);
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager):void
		{
			pm.topLayer.addChild(this);
			var cmd:UnparsedCommand = new UnparsedCommand("createController", createController, "Controller", "Create a widget for changing properties on the current scope (createController width height for instance)");
			DConsole(pm.console).addCommand(cmd);
			_scopeManager = pm.scopeManager;
		}
		
		public function shutdown(pm:PluginManager):void
		{
			pm.topLayer.removeChild(this);
			pm.console.removeCommand("createController");
			_scopeManager = null;
		}
		
		public function update(pm:PluginManager):void
		{
			graphics.clear();
			graphics.lineStyle(0, 0x808080);
			for each(var c:Controller in _controllers) {
				c.update();
			}
		}
		
		public function get descriptionText():String
		{
			return "Enables the creation of GUI widgets for interactive alteration of properties";
		}
		
		public function get dependencies():Vector.<Class> 
		{
			return null;
		}
		
	}

}
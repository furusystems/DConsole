package com.furusystems.dconsole2.plugins.inspectorviews.propertyview 
{
	import com.furusystems.dconsole2.core.inspector.AbstractInspectorView;
	import com.furusystems.dconsole2.core.interfaces.IThemeable;
	import com.furusystems.dconsole2.core.introspection.descriptions.AccessorDesc;
	import com.furusystems.dconsole2.core.introspection.descriptions.ChildScopeDesc;
	import com.furusystems.dconsole2.core.introspection.descriptions.MethodDesc;
	import com.furusystems.dconsole2.core.introspection.descriptions.VariableDesc;
	import com.furusystems.dconsole2.core.introspection.IntrospectionScope;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.style.GUIUnits;
	import com.furusystems.dconsole2.DConsole;
	import com.furusystems.dconsole2.IConsole;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.fieldtypes.*;
	import com.furusystems.dconsole2.plugins.inspectorviews.propertyview.tabs.*;
	import com.furusystems.messaging.pimp.MessageData;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class PropertyViewUtil extends AbstractInspectorView implements IThemeable
	{
		
		private var _tabs:TabCollection;
		private var _console:IConsole;
		public function PropertyViewUtil() 
		{
			super("Properties");
			_tabs = new TabCollection();
			_tabs.addEventListener(Event.CHANGE, onTabLayoutChange,false,0,true);
			content.addChild(_tabs);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			scrollXEnabled = false;
		}
		
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if(ControlField.FOCUSED_FIELD == null){
				scrollByDelta(0, e.delta * 5);7
			}else {
				
			}
		}
		public override function shutdown(pm:PluginManager):void 
		{
			super.shutdown(pm);
			
			pm.messaging.removeCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChange);
			pm.messaging.removeCallback(Notifications.THEME_CHANGED, onThemeChange);
		}
		override public function initialize(pm:PluginManager):void 
		{
			super.initialize(pm);
			_console = pm.console;
			pm.messaging.addCallback(Notifications.SCOPE_CHANGE_COMPLETE, onScopeChange);
			pm.messaging.addCallback(Notifications.THEME_CHANGED, onThemeChange);
			populate(pm.scopeManager.currentScope);
		}
		override public function onFrameUpdate(e:Event = null):void 
		{
			_tabs.updateTabs();
		}
		override public function populate(object:Object):void 
		{
			super.populate(object);
			var scope:IntrospectionScope = IntrospectionScope(object);
			_tabs.clear();
			var t:PropertyTab;
			var i:int;
			t = new OverviewTab(_console, scope);
			_tabs.add(t);
			t = new InheritanceTab(_console, scope);
			_tabs.add(t);
			if (scope.targetObject is DisplayObject) {
				t = new TransformTab(_console, scope);
				_tabs.add(t);
				t.averageSplits();
			}
			if(scope.children.length>0){
				t = new PropertyTab("Children");
				for (i = 0; i < scope.children.length; i++) 
				{
					var cd:ChildScopeDesc = scope.children[i];
					t.addField(new ChildField(_console, cd));
				}
				_tabs.add(t);
			}
			if(scope.methods.length>0){
				t = new PropertyTab("Methods");
				for (i = 0; i < scope.methods.length; i++) 
				{
					var md:MethodDesc = scope.methods[i];
					t.addField(new MethodField(_console.messaging,md));
				}
				t.sortFields();
				_tabs.add(t);
			}
			if(scope.variables.length>0){
				t = new PropertyTab("Variables");
				for (i = 0; i < scope.variables.length; i++) 
				{
					var vd:VariableDesc = scope.variables[i];
					t.addField(new PropertyField(_console, scope.targetObject, vd.name, vd.type)).width = scrollRect.width;
				}
				t.sortFields();
				_tabs.add(t);
				t.averageSplits();
			}
			if(scope.accessors.length>0){
				t = new PropertyTab("Accessors");
				for (i = 0; i < scope.accessors.length; i++) 
				{
					var ad:AccessorDesc = scope.accessors[i];
					var f:PropertyField;
					//if (ad.access == "writeonly") continue;
					f = new PropertyField(_console, scope.targetObject, ad.name, ad.type, ad.access);
					t.addField(f);
				}
				t.sortFields();
				_tabs.add(t);
				t.averageSplits();
			}
			scrollY = 0;
			resize();
		}
		private function onTabLayoutChange(e:Event):void 
		{
			scrollByDelta(0, 0);
		}
		private function onScopeChange(md:MessageData):void
		{
			var scope:IntrospectionScope = md.data as IntrospectionScope;
			populate(scope);
		}
		override public function resize():void 
		{
			if (!inspector) return;
			var rect:Rectangle = inspector.dims.clone();
			rect.height -= GUIUnits.SQUARE_UNIT;
			_tabs.width = rect.width;
			var r:Rectangle = scrollRect;
			r.width = rect.width;
			r.height = rect.height;
			scrollRect = r;
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.interfaces.IThemeable */
		
		public function onThemeChange(md:MessageData):void
		{
			_tabs.update(true);
		}
		
		override public function get descriptionText():String { 
			return "Adds a dynamically updating table of editable properties for the current scope";
		}
		
	}

}
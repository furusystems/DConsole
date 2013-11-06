package com.furusystems.dconsole2.core.introspection 
{
	import com.furusystems.dconsole2.core.introspection.descriptions.*;
	import com.furusystems.dconsole2.core.text.autocomplete.AutocompleteDictionary;
	import flash.display.DisplayObjectContainer;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class InspectionUtils
	{
		private static var desc:XML;
		private static var _lastClassDescribed:String;
		public function InspectionUtils() 
		{
			
		}
		public static function getAutoCompleteDictionary(o:*):AutocompleteDictionary {
			desc = describeTypeCached(o);
			var dict:AutocompleteDictionary = new AutocompleteDictionary();
			//get all methods
			var node:XML;
			var list:XMLList = desc..method;
			for each(node in list) {
				dict.addToDictionary(node.@name);
			}
			list = desc..variable;
			for each(node in list) {
				dict.addToDictionary(node.@name);
			}
			list = desc..method;
			for each(node in list) {
				dict.addToDictionary(node.@name);
			}
			list = desc..accessor;
			for each(node in list) {
				dict.addToDictionary(node.@name);
			}
			if (o is DisplayObjectContainer) {
				var i:int = o.numChildren;
				for (i > 0; i--; ) 
				{
					dict.addToDictionary(o.getChildAt(i).name);
				}
			}
			
			return dict;
		}
		public static function getInheritanceChain(o:*):Vector.<String> {
			var out:Vector.<String> = new Vector.<String>();
			desc = describeTypeCached(o);
			for each(var node:XML in desc..extendsClass) {
				out.push(node.@type);
			}
			return out;
		}
		public static function getInterfaces(o:*):Vector.<String> {
			var out:Vector.<String> = new Vector.<String>();
			desc = describeTypeCached(o);
			for each(var node:XML in desc..implementsInterface) {
				out.push(node.@type);
			}
			return out;
		}
		private static function describeTypeCached(target:*):XML {
			var _thisClassName:String = getQualifiedClassName(target);
			if (_lastClassDescribed != _thisClassName) {
				desc = describeType(target);
				_lastClassDescribed = _thisClassName;
			}
			return desc;
		}
		public static function getAccessors(o:*):Vector.<AccessorDesc> {
			desc = describeTypeCached(o);
			var vec:Vector.<AccessorDesc> = new Vector.<AccessorDesc>();
			var node:XML;
			var list:XMLList = desc..accessor;
			for each(node in list) {
				vec.push(new AccessorDesc(node));
			}
			return vec;
		}
		public static function getMethods(o:*):Vector.<MethodDesc> {
			desc = describeTypeCached(o);
			var vec:Vector.<MethodDesc> = new Vector.<MethodDesc>();
			var node:XML;
			var list:XMLList = desc..method;
			for each(node in list) {
				vec.push(new MethodDesc(node));
			}
			return vec;
		}
		public static function getVariables(o:*):Vector.<VariableDesc> {
			desc = describeTypeCached(o);
			var vec:Vector.<VariableDesc> = new Vector.<VariableDesc>();
			var node:XML;
			var list:XMLList = desc..variable;
			for each(node in list) {
				vec.push(new VariableDesc(node));
			}
			return vec;
		}
		
		//thanks Paulo Fierro :)
		public static function getMethodTooltip(scope:Object, methodName:String):String {
			var tip:String = methodName+"( "; 
			var desc:XMLList = describeTypeCached(scope)..method.(attribute("name").toLowerCase() == methodName.toLowerCase());
			if (desc.length() == 0) {
				throw new Error("No description for method " + methodName);
			}
			//<parameter index="1" type="String" optional="false"/>
			var first:Boolean = true;
			for each(var attrib:XML in desc..parameter) {
				if(!first) tip += ", ";
				tip += attrib.@type.toString().toLowerCase();
				if (attrib.@optional == "true") {
					tip += "[optional]";
				}				
				first = false;
			}
			tip += " ):"+desc.@returnType;
			return tip;
		}
		public static function getAccessorTooltip(scope:Object, accessorName:String):String {
			var tip:String = accessorName; 
			var desc:XMLList = describeTypeCached(scope)..accessor.(attribute("name").toLowerCase() == accessorName.toLowerCase());
			if (desc.length() == 0) {
				desc = describeTypeCached(scope)..variable.(attribute("name").toLowerCase() == accessorName.toLowerCase());
				if (desc.length() == 0) {
					throw new Error("No description");
				}
			}
			tip += ":" + desc.@type;
			if (desc.@access == "readonly") {
				tip += " (read only)";
			}
			return tip;
		}
		
		public static function getMethodArgs(func:Object):Array {
			var desc:XML = describeTypeCached(func);
			var out:Array = [];
			for each(var attrib:XML in desc..parameter) {
				out.push(attrib);
			}
			return out;
		}
		
		
	}

}
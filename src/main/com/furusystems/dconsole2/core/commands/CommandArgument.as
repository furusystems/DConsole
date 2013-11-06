package com.furusystems.dconsole2.core.commands {
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import com.furusystems.dconsole2.core.references.ReferenceManager;
	
	/**
	 * Constructs and encapsulates an interpreted argument
	 */
	public class CommandArgument {
		public var data:*;
		
		public function CommandArgument(data:String, commandManager:CommandManager, referenceManager:ReferenceManager, pluginManager:PluginManager, treatAsIntrospection:Boolean) {
			var tmp:* = data;
			tmp = pluginManager.runParsers(tmp);
			switch (data.charAt(0)) {
				case "(":
					tmp = tmp.slice(1, tmp.length - 1);
					tmp = commandManager.tryCommand(tmp, null, true);
					break;
				case "<":
					tmp = new XML(tmp);
					break;
			}
			if (tmp is String) {
				if (tmp == "false") {
					tmp = false;
				} else if (tmp == "true") {
					tmp = true;
				}
				try {
					//if(!treatAsIntrospection) tmp = referenceManager.parseForReferences([tmp])[0];
					tmp = referenceManager.parseForReferences([tmp])[0];
				} catch (e:Error) {
					
				}
					//try {
					//tmp = pluginManager.scopeManager.getPropertyValueOnObject(tmp);
					//}catch (e:Error) {
					//
					//}
			}
			this.data = tmp;
		}
		
		public function toString():String {
			return data.toString();
		}
	
	}

}
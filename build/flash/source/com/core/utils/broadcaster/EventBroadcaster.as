
class com.core.utils.broadcaster.EventBroadcaster extends MovieClip {

	var listeners:Array = [];
	
	function addListener( listenerOBJ:Object ):Boolean {
		removeListener(listenerOBJ);
		listeners.push(listenerOBJ);
		
		return true;
	}
	
	function removeListener( listenerOBJ:Object ):Boolean {
		var objExist = false;
		var num:Number = listeners.length;
		
		while (num--) {
			if (listenerOBJ == listeners[num]) {
				listeners.splice(num, 1);
				objExist = true;
			}
		}
		
		return objExist;
	}
	
	function removeAllListeners():Void {
		listeners = [];
	}
	
	function broadcastMessage( func:String ):Boolean {
		var funcExist:Boolean = true;
		var num:Number = listeners.length;
		arguments.shift();

		for (var a:Number = 0; a < num; a++) {
			listeners[a][func].apply(listeners[a], arguments);
		}
		
		return funcExist;
	}

}

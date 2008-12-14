import com.core.utils.broadcaster.EventBroadcaster;


class com.core.utils.controls.Button extends EventBroadcaster {

	private var message:String;
	private var data:Object;
	
	
	public function Button() {
		super();
	}
	
	public function setMessage( message:String ):Void {
		this.message = message;
	}
	
	public function getMessage():String {
		return message;
	}
	
	public function setData( data:Object ):Void {
		this.data = data;
	}
	
	public function getData():Object {
		return data;
	}
	
	public function onRollOver():Void {
		changeState("_over");
	}
	
	public function onRollOut():Void {
		changeState("_out");
	}
	
	private function changeState( newState:String ):Void {
	    gotoAndStop(newState);
	}
	
	public function onRelease():Void {
		broadcastMessage(message, {
			event: message, 
			target: this
		});
	}

}

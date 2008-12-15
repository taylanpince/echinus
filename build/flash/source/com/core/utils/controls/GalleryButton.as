import com.core.utils.controls.Button;

import mx.utils.Delegate;
import mx.transitions.Tween;


class com.core.utils.controls.GalleryButton extends Button {

    private var active:Boolean;
	private var rollover_message:String;
	private var rollout_message:String;
    
    private var btnHover:MovieClip;
    
    
    public function GalleryButton() {
        super();
        
        active = false;
        
        btnHover._alpha = 0;
    }
    
    public function onRollOver():Void {
        broadcastMessage(rollover_message, {
			event: rollover_message, 
			target: this
		});

        if (!active) {
            rollOver();
        }
    }
    
    private function rollOver():Void {
        new Tween(btnHover, "_alpha", mx.transitions.easing.Regular.easeOut, btnHover._alpha, 100, 1, true);
    }
    
    public function onRollOut():Void {
        broadcastMessage(rollout_message, {
			event: rollout_message, 
			target: this
		});
        
        if (!active) {
            rollOut();
        }
    }
    
    private function rollOut():Void {
        new Tween(btnHover, "_alpha", mx.transitions.easing.Regular.easeOut, btnHover._alpha, 0, 4, true);
    }
    
    public function onRelease():Void {
        if (!active) {
            super.onRelease();
        }
    }
    
    public function selectButton():Void {
        if (!active) {
            active = true;
            
            rollOver();
        }
    }
    
    public function deselectButton():Void {
        if (active) {
            active = false;
            
            rollOut();
        }
    }

}

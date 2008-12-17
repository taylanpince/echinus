import com.core.utils.controls.Button;

import mx.utils.Delegate;
import mx.transitions.Tween;


class com.core.utils.controls.GalleryButton extends Button {

    private var active:Boolean;
	private var rollover_message:String;
	private var rollout_message:String;
    
    private var btnHover:MovieClip;
    private var btnDefault:MovieClip;
    
    private var fadeOut:Tween;
    private var fadeIn:Tween;
    
    
    public function GalleryButton() {
        super();
        
        active = false;
        
        btnHover._alpha = 0;
    }
    
    public function onRollOver():Void {
        if (rollover_message) {
            broadcastMessage(rollover_message, {
    			event: rollover_message, 
    			target: this
    		});
        }

        if (!active) {
            rollOver();
        }
    }
    
    private function rollOver():Void {
        fadeIn.stop();
        
        fadeOut = new Tween(btnHover, "_alpha", mx.transitions.easing.Regular.easeOut, btnHover._alpha, 100, 1, true);
    }
    
    public function onRollOut():Void {
        if (rollout_message) {
            broadcastMessage(rollout_message, {
    			event: rollout_message, 
    			target: this
    		});
        }
        
        if (!active) {
            rollOut();
        }
    }
    
    private function rollOut():Void {
        fadeOut.stop();
        
        fadeIn = new Tween(btnHover, "_alpha", mx.transitions.easing.Regular.easeOut, btnHover._alpha, 0, 2, true);
    }
    
    public function onRelease():Void {
        if (!active) {
            markSeen();
            super.onRelease();
        }
    }
    
    public function selectButton():Void {
        if (!active) {
            active = true;
            markSeen();
            rollOver();
        }
    }
    
    public function deselectButton():Void {
        if (active) {
            active = false;
            
            rollOut();
        }
    }
    
    public function markSeen():Void {
        btnDefault._visible = false;
    }

}

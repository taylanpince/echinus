import com.core.utils.controls.ImageButton;

import mx.utils.Delegate;
import mx.transitions.Tween;


class com.core.utils.controls.GalleryButton extends ImageButton {

    private var active:Boolean;
    
    private var btnHover:MovieClip;
    
    
    public function GalleryButton() {
        super();
        
        active = false;
    }
    
    public function onRollOver():Void {
        if (!active) {
            rollOver();
        }
    }
    
    private function rollOver():Void {
        new Tween(btnImage, "_alpha", mx.transitions.easing.Regular.easeOut, btnImage._alpha, 100, 1, true);
        new Tween(btnHover, "_alpha", mx.transitions.easing.Regular.easeOut, btnHover._alpha, 100, 1, true);
    }
    
    public function onRollOut():Void {
        if (!active) {
            rollOut();
        }
    }
    
    private function rollOut():Void {
        new Tween(btnImage, "_alpha", mx.transitions.easing.Regular.easeOut, btnImage._alpha, image_alpha, 1, true);
        new Tween(btnHover, "_alpha", mx.transitions.easing.Regular.easeOut, btnHover._alpha, 0, 1, true);
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

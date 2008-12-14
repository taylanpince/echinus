import com.core.utils.controls.HoverButton;

import mx.transitions.Tween;


class com.core.utils.controls.NavButton extends HoverButton {
    
    private var title:String;
    private var init_color:Number;
    private var hover_color:Number;
    private var active:Boolean;
    
    private var btnTitle:MovieClip;
    private var btnShield:MovieClip;
    
	
	public function NavButton() {
		super();
		
	    btnTitle.text = title;
        btnTitle._width = btnShield._width = btnTitle.textWidth + 5;
        btnTitle._height = btnShield._height = btnTitle.textHeight + 5;
        
		active = false;
	}
	
	public function onRollOver():Void {
	    if (!active) {
    	    super.onRollOver();
    	}
	}
	
	public function onRollOut():Void {
	    if (!active) {
		    super.onRollOut();
		}
	}
	
	public function selectButton():Void {
	    if (!active) {
	        active = true;
	        btnTitle.textColor = hover_color;
	    }
	}
	
	public function deselectButton():Void {
	    active = false;
        btnTitle.textColor = init_color;
	}

}
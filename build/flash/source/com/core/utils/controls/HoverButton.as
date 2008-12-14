import com.core.utils.controls.Button;


class com.core.utils.controls.HoverButton extends Button {

    private var hover_color:Number;
    private var init_color:Number;
    
    private var btnTitle:MovieClip;
    
    
    public function HoverButton() {
        super();
        
        init_color = btnTitle.textColor;
    }
    
    public function onRollOver():Void {
	    btnTitle.textColor = hover_color;
    	
    	super.onRollOver();
	}
	
	public function onRollOut():Void {
	    btnTitle.textColor = init_color;
		
		super.onRollOut();
	}
	
	public function setHoverColor( color:Number ):Void {
	    hover_color = color;
	}

}

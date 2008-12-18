import com.core.utils.controls.HoverButton;

import mx.transitions.Tween;


class com.core.utils.controls.LinkButton extends HoverButton {
    
    private var title:String;
    private var text_color:Number;
    
    private var btnTitle:MovieClip;
    private var btnShield:MovieClip;
    
	
	public function LinkButton() {
		super();
		
	    btnTitle.textColor = init_color = text_color;
	    btnTitle.text = title.toLowerCase();
	    
        btnTitle._width = btnShield._width = btnTitle.textWidth + 5;
        btnTitle._height = btnShield._height = btnTitle.textHeight + 5;
	}

}
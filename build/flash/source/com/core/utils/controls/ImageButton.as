import com.core.utils.controls.Button;

import mx.utils.Delegate;
import mx.transitions.Tween;


class com.core.utils.controls.ImageButton extends Button {

    private var image_path:String;
    private var image_loader:MovieClipLoader;
    private var image_alpha:Number;
    private var manager:Object;
    private var index:Number;
    
    private var btnImage:MovieClip;
    private var btnLoader:MovieClip;
    
    
    public function ImageButton() {
        super();
        
        if (!image_alpha) {
            image_alpha = 100;
        }
        
        btnImage._alpha = 0;
        
        image_loader = new MovieClipLoader();
		var loadProxy:Object = new Object();
        
		loadProxy.onLoadInit = Delegate.create(this, imageLoaded);
		
		image_loader.addListener(loadProxy);
		image_loader.loadClip(image_path, btnImage);
    }
    
    private function imageLoaded():Void {
        new Tween(btnLoader, "_alpha", mx.transitions.easing.Regular.easeOut, btnLoader._alpha, 0, 1, true);
        new Tween(btnImage, "_alpha", mx.transitions.easing.Regular.easeOut, btnImage._alpha, image_alpha, 1, true);
        
        if (manager) {
            manager.imageLoaded(index);
        }
    }

}

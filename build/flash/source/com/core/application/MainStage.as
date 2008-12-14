import com.core.content.Categories

import mx.utils.Delegate;
import mx.transitions.Tween;

/**
 * MainStage
 * Main application class
 * 
 * @author Taylan Pince (taylanpince@gmail.com)
 * @date December 10, 2008
 */

class com.core.application.MainStage extends MovieClip {
    
    private var xmlPath:String;
    
    private var LoaderBar:MovieClip;
    
    
    public function MainStage() {
        LoaderBar._visible = false;
        
	    load();
	}
	
	private function load():Void {
	    LoaderBar._alpha = 0;
	    LoaderBar._visible = true;
	    
	    //LoaderBar.loaderBg.onRollOver = LoaderBar.loaderBg.onRollOut = LoaderBar.loaderBg.onRelease = function() {};
	    
	    new Tween(LoaderBar, "_alpha", mx.transitions.easing.Regular.easeOut, LoaderBar._alpha, 100, 0.6, true);
	    //new Tween(activeSection, "_alpha", mx.transitions.easing.Regular.easeOut, activeSection._alpha, 0, 0.6, true);
	    
	    Categories.getInstance(xmlPath);
	    
	    onEnterFrame = function() {
	        if (Categories.getInstance().isLoaded()) {
	            delete onEnterFrame;
	            //delete LoaderBar.loaderBg.onRollOver;
	            //delete LoaderBar.loaderBg.onRollOut;
	            //delete LoaderBar.loaderBg.onRelease;
	            
	            new Tween(LoaderBar, "_alpha", mx.transitions.easing.Regular.easeOut, LoaderBar._alpha, 0, 0.6, true);
	            
	            init();
	        }
	    };
	}
	
	private function init():Void {
	    trace("Initializing...");
	    trace("Loaded " + Categories.getInstance().getItemList().length + " categories.")
	}
    
}

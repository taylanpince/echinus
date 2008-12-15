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
    private var activeMenu:MovieClip;
    
    private var LoaderBar:MovieClip;
    private var Navigation:MovieClip;
    private var Gallery:MovieClip;
    
    
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
	    trace("Loaded " + Categories.getInstance().getItemList().length + " categories.");
	    
	    var categories:Array = Categories.getInstance().getItemList();
	    var offsetY:Number = 0;
	    
	    for (var iterator:Number = 0; iterator < categories.length; iterator++) {
	        var tempNavItem:MovieClip = Navigation.attachMovie("Nav Button", "nav_" + iterator, iterator, {
	            _y : offsetY,
	            message : "selectCategory",
	            data : categories[iterator].index,
	            title : categories[iterator].name,
	            hover_color : 0x6bb7cf
	        });
	        
	        offsetY += tempNavItem._height + 5;
	        
	        tempNavItem.addListener(this);
	        
	        if (iterator == 0) {
	            activeMenu = tempNavItem;
	            tempNavItem.selectButton(true);
	            
	            loadCategory(0);
	        }
	    }
	}
	
	private function selectCategory( evt:Object ):Void {
	    if (activeMenu != evt.target) {
    	    activeMenu.deselectButton();
    	    evt.target.selectButton();
    	    activeMenu = evt.target;
    	    
    	    loadCategory(evt.target.data);
	    }
	}
	
	private function loadCategory( index:Number ):Void {
	    trace("Total Pieces: " + Categories.getInstance().getItem(index).pieces.length);
	    
	    Gallery.reset();
	    Gallery.init(index);
	}
    
}

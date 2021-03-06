import com.core.content.Links
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
    
    private var linksPath:String;
    private var categoriesPath:String;
    private var activeMenu:MovieClip;
    
    private var LoaderBar:MovieClip;
    private var Navigation:MovieClip;
    private var Gallery:MovieClip;
    private var linksLoader:MovieClip;
    private var bgBox:MovieClip;
    
    
    public function MainStage() {
        LoaderBar._visible = false;
        
        var backgroundFadeIn:Tween = new Tween(bgBox, "_alpha", mx.transitions.easing.Regular.easeOut, bgBox._alpha, 100, 0.75, true);
        
        backgroundFadeIn.onMotionFinished = Delegate.create(this, load);
	}
	
	private function load():Void {
	    LoaderBar._alpha = 0;
	    LoaderBar._visible = true;
	    
	    new Tween(LoaderBar, "_alpha", mx.transitions.easing.Regular.easeOut, LoaderBar._alpha, 100, 0.75, true);
	    
	    Categories.getInstance(categoriesPath);
	    Links.getInstance(linksPath);
	    
	    onEnterFrame = function() {
	        if (Categories.getInstance().isLoaded() && Links.getInstance().isLoaded()) {
	            delete onEnterFrame;
	            
	            new Tween(LoaderBar, "_alpha", mx.transitions.easing.Regular.easeOut, LoaderBar._alpha, 0, 0.75, true);
	            
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
	    
	    var links:Array = Links.getInstance().getItemList();
	    var offsetY:Number = 0;
	    
	    for (var iterator:Number = 0; iterator < links.length; iterator++) {
	        var tempLinkItem:MovieClip = linksLoader.attachMovie("Link Button", "link_" + iterator, iterator, {
	            _y : offsetY,
	            message : "launchLink",
	            data : links[iterator].index,
	            title : links[iterator].text,
	            text_color : (links[iterator].color == "dark") ? 0x6bb7cf : 0xbcbec0,
	            hover_color : (links[iterator].color == "dark") ? 0xbcbec0 : 0x6bb7cf
	        });
	        
	        offsetY += tempLinkItem._height + 1;
	        
	        tempLinkItem.addListener(this);
	    }
	}
	
	private function launchLink( evt:Object ):Void {
	    getURL(Links.getInstance().getItem(evt.target.data).href);
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

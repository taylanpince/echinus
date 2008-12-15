import com.core.content.Categories;

import mx.utils.Delegate;
import mx.transitions.Tween;

/**
 * Gallery
 * Gallery section
 * 
 * @author Taylan Pince (taylanpince@gmail.com)
 * @date December 13, 2008
 */

class com.core.application.Gallery extends MovieClip {

    private var imagesList:Array;
    private var thumbsOffsetX:Number;
    private var thumbsOffsetY:Number;
    private var activeThumb:MovieClip;
    private var image_loader:MovieClipLoader;
    
    private var pageTitle:MovieClip;
    private var imageLoader:MovieClip;
    private var imageLoadingBar:MovieClip;
    private var imageTitle:MovieClip;
    private var thumbsLoader:MovieClip;
    private var thumbsMask:MovieClip;
    private var paginationBar:MovieClip;
    

	public function Gallery() {
	    super();
	    
	    thumbsOffsetX = thumbsOffsetY = 0;
	    
	    image_loader = new MovieClipLoader();
	}
	
	private function reset():Void {
	    image_loader.unloadClip(imageLoader);
	    
	    for (var iterator:Number = 0; iterator < imagesList.length; iterator++) {
	        thumbsLoader["thumb_" + iterator].removeMovieClip();
	    }
	    
	    thumbsOffsetX = thumbsOffsetY = 0;
	}
	
	public function init( index:Number ):Void {
	    trace("Initializing gallery...");
	    
	    imagesList = Categories.getInstance().getItem(index).pieces;
        
	    loadThumb(0);
	}
	
	private function loadThumb( index:Number ):Void {
        if (imagesList[index].images[0].thumb) {
    	    var tempBtn:MovieClip = thumbsLoader.attachMovie("Gallery Button", "thumb_" + index, index, {
                _x : thumbsOffsetX,
                _y : thumbsOffsetY,
                image_path : imagesList[index].images[0].thumb,
                image_alpha : 60,
                message : "showImage",
                data : index,
                index : index,
                manager : this
            });
            trace("Loading Thumbnail: " + imagesList[index].images[0].thumb);
            thumbsOffsetX += tempBtn._width + 10;
            
            if (thumbsOffsetX >= thumbsMask._width) {
                thumbsOffsetX = 0;
                thumbsOffsetY += thumbsMask._height + 10;
            }
            
            if (index == 1) {
                loadImage(0);
            }
            
            tempBtn.addListener(this);
        }
	}
	
	public function imageLoaded( index:Number ):Void {
	    loadThumb(index + 1);
	}
	
	private function loadImage( index:Number ):Void {
	    trace("Loading image: " + index);
	    
	    new Tween(imageLoadingBar, "_alpha", mx.transitions.easing.Regular.easeOut, imageLoadingBar._alpha, 100, 0.5, true);
	    new Tween(imageLoader, "_alpha", mx.transitions.easing.Regular.easeOut, imageLoader._alpha, 0, 0.5, true);
	    
	    if (activeThumb) {
	        activeThumb.deselectButton();
	    }
	    
	    activeThumb = thumbsLoader["thumb_" + index];
	    thumbsLoader["thumb_" + index].selectButton();
	    
		var loadProxy:Object = new Object();
        
		loadProxy.onLoadInit = Delegate.create(this, largeImageLoaded);
		
		image_loader.addListener(loadProxy);
		image_loader.loadClip(imagesList[index].src, imageLoader);
		
		imageTitle.productName.text = imagesList[index].title;
		
		if (imagesList[index].product_code) {
		    imageTitle.productName.text += "  " + imagesList[index].product_code;
		    
		    imageTitle.productLink.message = "loadProduct";
		    imageTitle.productLink.data = imagesList[index].product_code;
		    imageTitle.productLink.hover_color = 0xFFFFFF;
		    imageTitle.productLink.addListener(_parent);
		    
		    imageTitle.productLink._visible = true;
		} else {
		    imageTitle.productLink._visible = false;
		}
	}
	
	private function largeImageLoaded():Void {
	    if (imageTitle._x < imageLoader._x) {
	        new Tween(imageTitle, "_x", mx.transitions.easing.Regular.easeOut, imageTitle._x, imageLoader._x, 1, true);
	    }
	    
	    new Tween(imageLoadingBar, "_alpha", mx.transitions.easing.Regular.easeOut, imageLoadingBar._alpha, 0, 0.5, true);
	    new Tween(imageLoader, "_alpha", mx.transitions.easing.Regular.easeOut, imageLoader._alpha, 100, 0.5, true);
	}
	
	private function showImage( evt:Object ):Void {
	    loadImage(evt.target.data);
	}

}

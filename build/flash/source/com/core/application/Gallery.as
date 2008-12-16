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
    private var active_index:Number;
    private var active_sub_index:Number;
    
    private var imageLoader:MovieClip;
    private var imageLoadingBar:MovieClip;
    private var imageTitle:MovieClip;
    private var imageMask:MovieClip;
    private var thumbsLoader:MovieClip;
    private var thumbsMask:MovieClip;
    private var thumbsPreview:MovieClip;
    private var nextBtn:MovieClip;
    private var prevBtn:MovieClip;
    private var viewsLoader:MovieClip;
    

	public function Gallery() {
	    super();
	    
	    thumbsOffsetX = thumbsOffsetY = 0;
	    
	    image_loader = new MovieClipLoader();
	}
	
	private function reset():Void {
	    image_loader.unloadClip(imageLoader);
	    
	    for (var iterator:Number = 0; iterator < imagesList.length; iterator++) {
	        thumbsLoader["thumb_" + iterator].removeMovieClip();
	        thumbsPreview["preview_" + iterator].removeMovieClip();
	    }
	    
	    thumbsOffsetX = thumbsOffsetY = 0;
	    
	    if (imagesList[active_index].images.length > 1) {
    	    for (var iterator:Number = 0; iterator < imagesList[active_index].images.length; iterator++) {
                viewsLoader["view_" + iterator].removeMovieClip();
            }
	    }
	    
	    active_index = active_sub_index = null;
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
                message : "showImage",
                rollover_message : "previewImage",
                rollout_message : "cleanPreview",
                data : index
            });
            
            var tempPreview:MovieClip = thumbsPreview.attachMovie("Thumb Preview", "preview_" + index, index, {
                image_path : imagesList[index].images[0].thumb,
                _visible : false,
                manager : this,
                index : index
            });
            
            thumbsOffsetX += tempBtn._width + 4;
            
            if (thumbsOffsetX >= thumbsMask._width) {
                thumbsOffsetX = 0;
                thumbsOffsetY += thumbsMask._height + 8;
            }
            
            tempPreview.addListener(this);
            tempBtn.addListener(this);
        }
	}
	
	public function imageLoaded( index:Number ):Void {
	    loadThumb(index + 1);
	    
        if (index == 0) {
            loadImage(0);
        }
	}
	
	public function previewImage( evt:Object ):Void {
	    thumbsPreview["preview_" + evt.target.data]._visible = true;
	}
	
	public function cleanPreview( evt:Object ):Void {
	    thumbsPreview["preview_" + evt.target.data]._visible = false;
	}
	
	private function loadImage( index:Number, sub_index:Number ):Void {
	    if (sub_index == null) {
	        sub_index = 0;
	    }
	    
	    if (active_index && active_index != index) {
            for (var iterator:Number = 0; iterator < imagesList[active_index].images.length; iterator++) {
                viewsLoader["view_" + iterator].removeMovieClip();
            }
        }
	    
	    if (imagesList[index].images.length > 1) {
	        if (active_index != index) {
	            var viewsOffsetX:Number = 0;
	            
	            for (var iterator:Number = 0; iterator < imagesList[index].images.length; iterator++) {
	                var tempView:MovieClip = viewsLoader.attachMovie("View Button", "view_" + iterator, iterator, {
	                    _x : viewsOffsetX,
	                    message : "showSubImage",
	                    data : [index, iterator]
	                });
	                
	                viewsOffsetX += tempView._width + 5;
	                
	                if (iterator == sub_index) {
	                    tempView.selectButton();
	                }
	            }
	        } else if (active_index == index) {
	            viewsLoader["view_" + active_sub_index].deselectButton();
	            viewsLoader["view_" + sub_index].selectButton();
	        }
	    }
	    
	    active_index = index;
	    active_sub_index = sub_index;
	    
	    trace("Loading image: " + index + " / " + sub_index);
	    
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
		image_loader.loadClip(imagesList[index].images[sub_index].src, imageLoader);
		
		imageTitle.text = imagesList[index].images[sub_index].title;
		imageTitle._width = imageTitle.textWidth + 10;
		imageTitle._x = imageMask._x + ((imageMask._width - imageTitle._width) / 2);
	}
	
	private function largeImageLoaded():Void {
	    imageLoader._x = imageMask._x + ((imageMask._width - imageLoader._width) / 2);
	    imageLoader._y = imageMask._y + ((imageMask._height - imageLoader._height) / 2);
		
	    new Tween(imageLoadingBar, "_alpha", mx.transitions.easing.Regular.easeOut, imageLoadingBar._alpha, 0, 0.5, true);
	    new Tween(imageLoader, "_alpha", mx.transitions.easing.Regular.easeOut, imageLoader._alpha, 100, 0.5, true);
	    
	    new Tween(viewsLoader, "_x", mx.transitions.easing.Regular.easeOut, viewsLoader._x, imageLoader._x + imageLoader._width - viewsLoader._width, 0.5, true);
	    new Tween(viewsLoader, "_y", mx.transitions.easing.Regular.easeOut, viewsLoader._y, imageLoader._y - viewsLoader._height - 5, 0.5, true);
	}
	
	private function showSubImage( evt:Object ):Void {
	    loadImage(evt.target.data[0], evt.target.data[1]);
	}
	
	private function showImage( evt:Object ):Void {
	    loadImage(evt.target.data);
	}

}

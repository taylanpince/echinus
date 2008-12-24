import com.core.content.Categories;

import mx.utils.Delegate;
import mx.transitions.Tween;

import flash.filters.DropShadowFilter;

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
    private var shadow_filter:DropShadowFilter;
    
    private var imageLoader:MovieClip;
    private var imageLoadingBar:MovieClip;
    private var imageTitle:MovieClip;
    private var imageTitleMask:MovieClip;
    private var imageMask:MovieClip;
    private var thumbsLoader:MovieClip;
    private var thumbsMask:MovieClip;
    private var thumbsPreview:MovieClip;
    private var thumbsPreviewMask:MovieClip;
    private var thumbsLoadingBar:MovieClip;
    private var thumbButton:MovieClip;
    private var nextBtn:MovieClip;
    private var prevBtn:MovieClip;
    private var viewsLoader:MovieClip;
    

	public function Gallery() {
	    super();
	    
	    thumbsOffsetX = thumbsOffsetY = 0;
	    
	    imageTitle.text = "";
	    nextBtn._visible = prevBtn._visible = false;
	    
	    image_loader = new MovieClipLoader();
	    
	    shadow_filter = new DropShadowFilter(5, 60, 0x000000, 0.25);
	    
	    imageLoadingBar._alpha = thumbsLoadingBar._alpha = 0;
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
	    
	    imageTitle.text = "";
	    nextBtn._visible = prevBtn._visible = false;
	    
	    active_index = active_sub_index = null;
	    
	    imageLoadingBar._alpha = thumbsLoadingBar._alpha = 0;
	}
	
	public function init( index:Number ):Void {
	    trace("Initializing gallery...");
	    
	    imagesList = Categories.getInstance().getItem(index).pieces;
	    
	    nextBtn.onRelease = Delegate.create(this, loadNextImage);
	    prevBtn.onRelease = Delegate.create(this, loadPrevImage);
	    
	    thumbsPreviewMask._xscale = thumbsPreviewMask._yscale = 100;
	    
	    var thumbsAreaTop:Number = Math.floor(this._parent.Navigation._y + this._parent.Navigation._height);
	    var thumbsAreaBottom:Number = Math.floor(this._parent.linksLoader._y);
	    
	    thumbsMask._height = Math.ceil(imagesList.length / (thumbsMask._width / (thumbButton._width + 4))) * (thumbButton._height + 8) - 8;
	    
	    var thumbsAreaMargin:Number = Math.floor(thumbsMask._y - thumbsPreview._y - thumbsPreviewMask._height);
	    var thumbsAreaHeight:Number = Math.floor(thumbsPreviewMask._height + thumbsMask._height + (thumbsAreaMargin * 2));
	    
	    thumbsPreview._y = thumbsPreviewMask._y = thumbsAreaTop + Math.floor((thumbsAreaBottom - thumbsAreaTop - thumbsAreaHeight) / 2);
	    thumbsPreviewMask._y += thumbsPreviewMask._height / 2;
	    thumbsMask._y = thumbsLoader._y = thumbsPreview._y + thumbsPreviewMask._height + thumbsAreaMargin;
	    thumbsLoadingBar._y = thumbsMask._y + thumbsMask._height + thumbsAreaMargin;
	    
	    thumbsPreviewMask._xscale = thumbsPreviewMask._yscale = 0.1;
        
        new Tween(thumbsLoadingBar, "_alpha", mx.transitions.easing.Regular.easeOut, thumbsLoadingBar._alpha, 100, 1, true);
        
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
                thumbsOffsetY += thumbsLoader._height + 8;
            }
            
            tempPreview.addListener(this);
            tempBtn.addListener(this);
        } else if (index >= imagesList.length) {
            new Tween(thumbsLoadingBar, "_alpha", mx.transitions.easing.Regular.easeOut, thumbsLoadingBar._alpha, 0, 1, true);
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
	    
	    new Tween(thumbsPreviewMask, "_xscale", mx.transitions.easing.Regular.easeOut, thumbsPreviewMask._xscale, 100, 0.75, true);
	    new Tween(thumbsPreviewMask, "_yscale", mx.transitions.easing.Regular.easeOut, thumbsPreviewMask._yscale, 100, 0.75, true);
	}
	
	public function cleanPreview( evt:Object ):Void {
	    new Tween(thumbsPreviewMask, "_xscale", mx.transitions.easing.Regular.easeOut, thumbsPreviewMask._xscale, 0.1, 0.75, true);
	    var previewScale:Tween = new Tween(thumbsPreviewMask, "_yscale", mx.transitions.easing.Regular.easeOut, thumbsPreviewMask._yscale, 0.1, 0.75, true);
	    
	    previewScale.onMotionFinished = function() {
    	    thumbsPreview["preview_" + evt.target.data]._visible = false;
	    };
	}
	
	public function loadNextImage():Void {
	    if (imagesList[active_index].images.length > (active_sub_index + 1)) {
	        loadImage(active_index, (active_sub_index + 1));
	    } else if (imagesList.length > (active_index + 1)) {
	        loadImage(active_index + 1);
	    }
	}
	
	public function loadPrevImage():Void {
	    if (active_sub_index > 0) {
	        loadImage(active_index, (active_sub_index - 1));
	    } else if (active_index > 0) {
	        loadImage((active_index - 1));
	    }
	}
	
	private function loadImage( index:Number, sub_index:Number ):Void {
	    if (sub_index == null) {
	        sub_index = 0;
	    }
	    
	    viewsLoader._alpha = 0;
	    
	    if (active_index != index) {
    	    for (var item:String in viewsLoader) {
    	        if (typeof viewsLoader[item] == "movieclip") {
    	            viewsLoader[item].removeMovieClip();
    	        }
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
	    
	    prevBtn._visible = (active_index > 0 || active_sub_index > 0);
	    nextBtn._visible = !(active_index == (imagesList.length - 1) && active_sub_index == (imagesList[active_index].images.length - 1));
	    
	    trace("Loading image: " + index + " / " + sub_index);
	    
	    new Tween(imageLoadingBar, "_alpha", mx.transitions.easing.Regular.easeOut, imageLoadingBar._alpha, 100, 1, true);
	    new Tween(imageLoader, "_alpha", mx.transitions.easing.Regular.easeOut, imageLoader._alpha, 0, 1, true);
	    
	    if (activeThumb) {
	        activeThumb.deselectButton();
	    }
	    
	    activeThumb = thumbsLoader["thumb_" + index];
	    thumbsLoader["thumb_" + index].selectButton();
	    
		var loadProxy:Object = new Object();
        
		loadProxy.onLoadInit = Delegate.create(this, largeImageLoaded);
		
		image_loader.addListener(loadProxy);
		image_loader.loadClip(imagesList[index].images[sub_index].src, imageLoader);
		
		imageTitleMask._width = 0;
	    
		imageTitle.text = imagesList[index].images[sub_index].title;
		imageTitle._width = imageTitle.textWidth + 10;
		imageTitle._x = imageMask._x + ((imageMask._width - imageTitle._width) / 2);
	}
	
	private function largeImageLoaded():Void {
	    imageLoader._x = imageMask._x + ((imageMask._width - imageLoader._width) / 2);
	    imageLoader._y = imageMask._y + ((imageMask._height - imageLoader._height) / 2);
		
	    new Tween(imageLoadingBar, "_alpha", mx.transitions.easing.Regular.easeOut, imageLoadingBar._alpha, 0, 1, true);
	    new Tween(imageLoader, "_alpha", mx.transitions.easing.Regular.easeOut, imageLoader._alpha, 100, 1, true);
	    
	    viewsLoader._x = Math.floor(imageLoader._x + imageLoader._width - viewsLoader._width);
	    viewsLoader._y = Math.floor(imageLoader._y - viewsLoader._height - 5);
	    
	    new Tween(viewsLoader, "_alpha", mx.transitions.easing.Regular.easeOut, viewsLoader._alpha, 100, 0.5, true);
	    
	    if (imagesList[active_index].images[active_sub_index].shadow) {
		    imageLoader.filters = [shadow_filter];
		} else {
		    imageLoader.filters = [];
		}
		
		new Tween(imageTitleMask, "_width", mx.transitions.easing.Regular.easeOut, imageTitleMask._width, imageTitle._width, 1, true);
	}
	
	private function showSubImage( evt:Object ):Void {
	    loadImage(evt.target.data[0], evt.target.data[1]);
	}
	
	private function showImage( evt:Object ):Void {
	    loadImage(evt.target.data);
	}

}

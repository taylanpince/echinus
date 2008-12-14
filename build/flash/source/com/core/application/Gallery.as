import com.core.content.Prints;

import mx.utils.Delegate;
import mx.transitions.Tween;

/**
 * PrintsGallery
 * Prints Gallery section
 * 
 * @author Taylan Pince (taylanpince@gmail.com)
 * @date December 13, 2008
 */

class com.core.application.PrintsGallery extends MovieClip {

    private var galleryLoaded:Boolean;
    private var imagesList:Array;
    private var thumbsInitPosX:Number;
    private var activeThumb:MovieClip;
    private var currentPage:Number;
    private var itemsPerPage:Number;
    private var totalPages:Number;
    private var pages:Array;
    private var image_loader:MovieClipLoader;
    
    private var pageTitle:MovieClip;
    private var imageLoader:MovieClip;
    private var imageLoadingBar:MovieClip;
    private var imageTitle:MovieClip;
    private var thumbsLoader:MovieClip;
    private var thumbsMask:MovieClip;
    private var paginationBar:MovieClip;
    

	public function PrintsGallery() {
	    super();
	    
	    itemsPerPage = 9;
	    galleryLoaded = false;
	    thumbsInitPosX = thumbsLoader._x;
	    
	    image_loader = new MovieClipLoader();
	}
	
	private function reset():Void {
	    image_loader.unloadClip(imageLoader);
	    
	    for (var iterator:Number = 0; iterator < imagesList.length; iterator++) {
	        thumbsLoader["thumb_" + iterator].removeMovieClip();
	    }
	}
	
	public function load():Void {
	    if (!galleryLoaded) {
    	    reset();
    	    
    	    Gallery.getInstance(_parent.xmlPath);
	    }
	}
	
	public function init():Void {
	    trace("Initializing gallery...");
	    
	    if (!galleryLoaded) {
	        galleryLoaded = true;
	        
	        thumbsLoader._x = thumbsInitPosX;
	        
    	    imagesList = Prints.getInstance().getItemList();
	        
    	    initPagination();
    	    loadThumb(0);
    	}
	}
	
	public function clean():Void {
	    
	}
	
	private function initPagination():Void {
	    if (imagesList.length > itemsPerPage) {
	        totalPages = Math.ceil(imagesList.length / itemsPerPage);
	        pages = new Array();
    	    currentPage = 0;
	        
	        var buttonOffsetX:Number = 0;
	        
	        for (var iterator:Number = 0; iterator < totalPages; iterator++) {
	            var tempBtn:MovieClip = paginationBar.pageLoader.attachMovie("Paginator Button", "page_" + iterator, iterator, {
	                _x : buttonOffsetX,
	                _y : 0,
	                hover_color : 0x999999,
	                title : String(iterator + 1),
	                message : "selectPage",
	                data : iterator
	            });
	            
	            buttonOffsetX += tempBtn._width + 5;
	            
	            if (iterator == 0) {
	                tempBtn.selectButton();
	            }
	            
	            tempBtn.addListener(this);
	            
	            pages[iterator] = new Object();
	            pages[iterator].isLoaded = false;
	            pages[iterator].offsetX = 0;
	            pages[iterator].offsetY = 0;
	            pages[iterator].numRows = 0;
	        }
	        
	        paginationBar.prevBtn.message = "gotoPrevPage";
	        paginationBar.prevBtn.addListener(this);
	        paginationBar.prevBtn._visible = false;
	        
	        paginationBar.nextBtn.message = "gotoNextPage";
	        paginationBar.nextBtn.addListener(this);
	        paginationBar.nextBtn._visible = true;
	        
	        paginationBar.pageLoader._x = ((paginationBar._width - 10) / 2) - (paginationBar.pageLoader._width / 2);
	        paginationBar.prevLine._x = paginationBar.pageLoader._x - 5;
	        paginationBar.prevBtn._x = paginationBar.pageLoader._x - paginationBar.prevBtn._width - 10;
	        paginationBar.nextBtn._x = paginationBar.pageLoader._x + paginationBar.pageLoader._width + 10;
	        
	        paginationBar._visible = true;
	    } else {
	        totalPages = 1;
	        currentPage = 0;
	        
	        pages = new Array();
	        pages[0] = new Object();
            pages[0].isLoaded = false;
            pages[0].offsetX = 0;
            pages[0].offsetY = 0;
            pages[0].numRows = 0;
            
	        paginationBar._visible = false;
	    }
	}
	
	private function gotoPrevPage():Void {
	    if (currentPage > 0) {
	        gotoPage(currentPage - 1);
	    }
	}
	
	private function gotoNextPage():Void {
	    if (currentPage < (totalPages - 1)) {
	        gotoPage(currentPage + 1);
	    }
	}
	
	private function gotoPage( page:Number ):Void {
	    if (page != currentPage) {
    	    trace("Going to page: " + page);

    	    paginationBar.pageLoader["page_" + currentPage].deselectButton();

    	    currentPage = page;
    	    paginationBar.pageLoader["page_" + page].selectButton();

    	    if (page > 0) {
    	        paginationBar.prevBtn._visible = true;
    	    } else {
    	        paginationBar.prevBtn._visible = false;
    	    }

    	    if (page < (totalPages - 1)) {
    	        paginationBar.nextBtn._visible = true;
    	    } else {
    	        paginationBar.nextBtn._visible = false;
    	    }

    	    if (!pages[page].isLoaded) {
    	        loadThumb(page * itemsPerPage);
    	    }

    	    new Tween(thumbsLoader, "_x", mx.transitions.easing.Regular.easeOut, thumbsLoader._x, (thumbsInitPosX - (page * thumbsMask._width) - (page * 10)), 1, true);
    	}
	}
	
	public function selectPage( evt:Object ):Void {
	    gotoPage(evt.target.data);
	}
	
	private function loadThumb( index:Number ):Void {
	    var page:Number = Math.floor(index / itemsPerPage);
	    var pageOffsetX:Number = (thumbsMask._width * page) + (10 * page);
	    
	    if (index < (itemsPerPage * (page + 1))) {
	        if ((index == (itemsPerPage * (page + 1)) - 1) || (index == (imagesList.length - 1))) {
	            var tempManager:Object = null;
	            pages[page].isLoaded = true;
	        } else {
	            var tempManager:Object = this;
	        }
	        
	        if (imagesList[index].thumb) {
	            trace("index: " + index + " / page: " + page + " / offsetX: " + pages[page].offsetX);
	            
        	    var tempBtn:MovieClip = thumbsLoader.attachMovie("Gallery Button", "thumb_" + index, index, {
                    _x : pages[page].offsetX + pageOffsetX,
                    _y : pages[page].offsetY,
                    image_path : imagesList[index].thumb,
                    image_alpha : 60,
                    message : "showImage",
                    data : index,
                    index : index,
                    manager : tempManager
                });
                
                pages[page].offsetX += tempBtn._width + 10;
                
                if (pages[page].offsetX > thumbsMask._width) {
                    pages[page].numRows++;
                    pages[page].offsetX = 0;
                    pages[page].offsetY = (pages[page].numRows * tempBtn._height) + (pages[page].numRows * 10);
                }
                
                if (index == 1) {
                    loadImage(0);
                }
                
                tempBtn.addListener(this);
            }
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
		    imageTitle.productLink.btnTitle.text = Locale.getInstance().getLocaleString("GALLERY_DETAILS");
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
	
	public function isLoaded():Boolean {
	    return Prints.getInstance().isLoaded();
	}

}

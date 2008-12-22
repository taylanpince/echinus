import mx.utils.Delegate;

/**
 * Categories
 * Loads the main categories and the images under them
 *
 * @author Taylan Pince (taylanpince@gmail.com)
 * @date December 13, 2008
 */

class com.core.content.Categories {
    
    private var contentXML:XML;
	private var contentTable:Array;
	private var contentLoaded:Boolean;
	
	private static var instance:Categories;
	
	
	public static function getInstance( xmlPath:String ):Categories {
		if (!instance) {
			instance = new Categories(xmlPath);
		}
		
		return instance;
	}
	
	private function Categories( contentPath:String ) {
		contentTable = new Array();
		
		contentLoaded = false;
		
		contentXML = new XML();
		contentXML.ignoreWhite = true;
		contentXML.onLoad = Delegate.create(this, parseFile);
		contentXML.load(contentPath);
	}
	
	private function parseFile( success:Boolean ):Void {
		if (success) {
			var rootNode:XMLNode = contentXML.firstChild;
			var contentList:Array = rootNode.childNodes;
			
			for (var iterator:Number = 0; iterator < contentList.length; iterator++) {
				var contentNode:XMLNode = contentList[iterator];
				
				contentTable[iterator] = new Object();
				
				contentTable[iterator].index = iterator;
				contentTable[iterator].name = contentNode.childNodes[0].firstChild.nodeValue;
				contentTable[iterator].slug = contentNode.childNodes[1].firstChild.nodeValue;
				
				contentTable[iterator].pieces = new Array();
				for (var sub_iterator:Number = 0; sub_iterator < contentNode.childNodes[2].childNodes.length; sub_iterator++) {
				    contentTable[iterator].pieces[sub_iterator] = new Object();
				    
				    contentTable[iterator].pieces[sub_iterator].images = new Array();
				    for (var img_iterator:Number = 0; img_iterator < contentNode.childNodes[2].childNodes[sub_iterator].childNodes.length; img_iterator++) {
				        contentTable[iterator].pieces[sub_iterator].images[img_iterator] = new Object();
				        
    				    contentTable[iterator].pieces[sub_iterator].images[img_iterator].src = contentNode.childNodes[2].childNodes[sub_iterator].childNodes[img_iterator].attributes.src;
    				    contentTable[iterator].pieces[sub_iterator].images[img_iterator].thumb = contentNode.childNodes[2].childNodes[sub_iterator].childNodes[img_iterator].attributes.thumb;
    				    contentTable[iterator].pieces[sub_iterator].images[img_iterator].title = contentNode.childNodes[2].childNodes[sub_iterator].childNodes[img_iterator].childNodes[0].firstChild.nodeValue;
    				    contentTable[iterator].pieces[sub_iterator].images[img_iterator].shadow = (contentNode.childNodes[2].childNodes[sub_iterator].childNodes[img_iterator].attributes.shadow == "true") ? true : false;
				    }
				}
			}
			
			contentLoaded = true;
			
			trace(contentList.length + " categories loaded.");
		} else {
			trace("Problem loading the categories file!");
		}		
	}
	
	public function getItem( index:Number ):Object {
	    if (contentTable[index]) {
    		return contentTable[index];
	    } else {
	        trace("Item could not be found!");

    		return null;
	    }
	}
	
	public function getItemList():Array {
	    return contentTable;
	}
	
	public function isLoaded():Boolean {
		return contentLoaded;
	}

}

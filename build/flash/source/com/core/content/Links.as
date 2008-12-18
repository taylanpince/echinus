import mx.utils.Delegate;

/**
 * Links
 * Loads the links on the sidebar
 *
 * @author Taylan Pince (taylanpince@gmail.com)
 * @date December 18, 2008
 */

class com.core.content.Links {
    
    private var contentXML:XML;
	private var contentTable:Array;
	private var contentLoaded:Boolean;
	
	private static var instance:Links;
	
	
	public static function getInstance( xmlPath:String ):Links {
		if (!instance) {
			instance = new Links(xmlPath + "links.xml");
		}
		
		return instance;
	}
	
	private function Links( contentPath:String ) {
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
				contentTable[iterator].href = contentNode.attributes.href;
				contentTable[iterator].color = contentNode.attributes.color;
				contentTable[iterator].text = contentNode.firstChild.nodeValue;
			}
			
			contentLoaded = true;
			
			trace(contentList.length + " links loaded.");
		} else {
			trace("Problem loading the links file!");
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

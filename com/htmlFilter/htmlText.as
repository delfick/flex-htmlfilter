package com.htmlFilter
{
#  htmlText.as
#  
#  Copyright (C) 2008 - Stephen Moore
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#   
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#   
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330,
#  Boston, MA 02111-1307, USA.

	import mx.containers.Canvas;
	
	
	public class htmlText extends Canvas
	{
		import flash.events.Event;
		import mx.collections.ArrayCollection;
		import mx.core.UIComponent;
		import mx.core.EdgeMetrics;
		import flash.events.MouseEvent;
		import com.htmlFilter.text;
		import mx.containers.HBox;
		import flash.display.Sprite;
    	import flash.net.URLLoader;
    	import flash.net.URLRequest;
    	import flash.text.StyleSheet;
    	import qs.controls.SuperImage;
    	import com.htmlFilter.optionAndStyles;
    	import com.htmlFilter.box;
		
		private var theParts:ArrayCollection = new ArrayCollection();
		
		private var currentPart:Number = 0;
		
		private var theText:String;
		
		private var customCss:Boolean = false;
		
		private var cssLoaded:Boolean = false;
		
		private var styles:StyleSheet;
		
		private var loader:URLLoader;
		
		public function htmlText ()
		{
			super();
			
			horizontalScrollPolicy="off";
			
			verticalScrollPolicy = "on";
			
			styles = optionAndStyles.getStyles();
		}
		
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if (numChildren == 0)
            {
            	invalidateProperties() 
            }
    
            var vm:EdgeMetrics = viewMetricsAndPadding;
    
            var yOfComp:Number = 0;
            
            var toX:Number;
            
            var obj:UIComponent;
                
            for (var i:int = 0; i < numChildren; i++)
            {
                obj = UIComponent(getChildAt(i));
                toX = obj.x;
                if (theParts.getItemAt(i).Type == "table")
                {
                	toX = (width-obj.width-10)/2
                }
                else if (theParts.getItemAt(i).Type == "image")
                {
                	toX = (width-obj.width-10)/2
                }
                obj.move(toX, yOfComp);
                yOfComp = yOfComp + obj.height;
            }
            
            
        }
        
        override protected function commitProperties():void
        {
			findParts();
			removeAllChildren();
        	if (customCss)
        	{
        		if (cssLoaded)
        		{
					addNewItems();
				}
			}
			else
			{
				addNewItems();
			}      	
        }
        
        private function addNewItems():void
        {
		    for each (var part:Object in theParts)
		    {
		    	if (part.Type == "text")
		    	{
		    		addNewItem("text", part);
		    	}
		    	else if (part.Type == "table")
		    	{
		    		addNewItem("table", part);
		    	}
		    	else if (part.Type == "image")
		    	{
		    		addNewItem("image", part);
		    	}
		    	else
		    	{
		    		trace("part type : " + part.Type + " doesn't exist");
		    	}
		    }
        }
        
        private function findParts():void
        {
        	theParts = new ArrayCollection();
        	currentPart = -1;
        	addItem("text", 0);
        	var tags:RegExp = new RegExp("<(?P<tag>[^<>]*)>", "g");
			var result:Array = tags.exec(theText);
			var prevPart:Object;
				 
			while (result != null)
			{
				if (result.tag.substr(0,5) == "table")
				{
					prevPart = theParts.getItemAt(currentPart);
					prevPart.Text = theText.substring(prevPart.startIndex, result.index);
					addItem("table", result.index);
				}
				if (result.tag.substr(0,5) == "image")
				{
					prevPart = theParts.getItemAt(currentPart);
					prevPart.Text = theText.substring(prevPart.startIndex, result.index);
					addItem("image", result.index, result.tag);
				}
				else if (result.tag == "/table")
				{
					prevPart = theParts.getItemAt(currentPart);
					prevPart.Text = theText.substring(prevPart.startIndex, result.index + result[0].length);
					addItem("text",result.index);
				}
				result = tags.exec(theText);
			}
			
			prevPart = theParts.getItemAt(currentPart);
			if (theText != null)
			{
				prevPart.Text = theText.substring(prevPart.startIndex, theText.length);
			}
			else
			{
				prevPart.Text = "This page is loading";
			}
        }
        
        private function addNewItem(inType:String, inPart:Object):void
        {        	
        	switch (inType)
        	{
		    	case "text" :
					var newTextField:com.htmlFilter.text = optionAndStyles.getHtmlText();		
					newTextField.htmlText = inPart.Text;
				//	trace(inPart.Text);
			
					var newBox:box = new box(box.TEXT);
					newBox.addChild(newTextField);
					newTextField.styleSheet = styles;
					addChild(newBox);
					break;
				
				case "table" :
					var newTable:htmlTable = new htmlTable(inPart, styles);
					newTable.percentWidth = 80;
					addChild(newTable);
					break;
				
				case "image" :
					var newImage:SuperImage = new SuperImage();
					newImage.source = inPart.src;
					inPart.width == null
					?
						newImage.percentWidth = 95
					:
						newImage.width = inPart.width;
					newImage.cacheName = inPart.cacheName;
					newImage.setStyle("borderStyle", "none");
					addChild(newImage);
					break;
			}
        }
        
        private function addItem(inType:String, inIndex:Number, inTag:String = ""):void
        {
        	var newPart:Object;
        	switch (inType)
        	{
        		case "text" :
					newPart = new Object;
					newPart.startIndex = inIndex;
					newPart.Text = null;
					newPart.Type = "text"
					theParts.addItem(newPart);
					currentPart++;
					break;
				
				case "table" :
					newPart = new Object;
					newPart.startIndex = inIndex;
					newPart.Type = "table"
					newPart.Text = null;
					theParts.addItem(newPart);
					currentPart++;
					break;
				
				case "image" :
					var src:String = null;
					var width:Number = -1;
					var cacheName:String = "default";
					newPart = new Object;
					
					var theOptions:ArrayCollection = optionAndStyles.findOptions(inTag);
					for each (var option:Array in theOptions)
					{
						switch (option.optionName)
						{
							case "src" :
								src = option.optionValue;
								break;
							case "width" :
								width = Number(option.optionValue);
								break;
							case "cache" :
								option.optionValue == "null"
								?
									cacheName = null
								:
									cacheName = option.optionValue;
								break;
						}
					}
					if (src != null)
					{
						width > 0
						?
							newPart.width = width
						:
							newPart.percentWidth = 95;
						newPart.src = src;
						newPart.startIndex = inIndex;
						newPart.Type = "image"
						newPart.Text = null;
						newPart.cacheName = cacheName;
						theParts.addItem(newPart);
						currentPart++;
					}
					break;
			}

        }
        
		
		[Bindable]
		public function get text ():String
		{
			return theText;
		}
		public function set text (inText:String):void
		{
			theText = inText;
			invalidateProperties() 
		}
		
		public function set cssFile (inCssFile:String):void
		{
			customCss = true;
			
			var req:URLRequest = new URLRequest(inCssFile);
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onCSSFileLoaded);
            try
            {
                loader.load(req);
            }
            catch (error:ArgumentError)
            {
                trace("An ArgumentError has occurred.");
            }
            catch (error:SecurityError)
            {
                trace("A SecurityError has occurred.");
            }
		}		
		
        public function onCSSFileLoaded(event:Event):void
        {
            styles = new StyleSheet();
            styles.parseCSS(loader.data);
            cssLoaded = true;
        }
	}
	
}



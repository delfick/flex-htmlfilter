package com.htmlFilter
{
	public class optionAndStyles
	{
		import mx.collections.ArrayCollection;
    	import flash.text.StyleSheet;
    	
    	static private var setStyles:Boolean = false;
		
		static public function findOptions(inString:String):ArrayCollection
		{    			
			var optionArray:ArrayCollection = new ArrayCollection;
			var pattern:RegExp = new RegExp("(?P<optionName>[^\" ]+)=\"(?P<optionValue>[^\"]*)\"","g");
			var foundAnOption:Array;
			foundAnOption = pattern.exec(inString);
			while (foundAnOption != null)
			{
				optionArray.addItem(foundAnOption);
				foundAnOption = pattern.exec(inString);
			}
		
			return optionArray;
				
		}
		
		static public function findTag(inTag:String, inText:String):Array
		{
			var theRegExp:String = "<" + inTag + "(?P<options>[^<>]+)?>(?P<value>[^<>]+)</" + inTag + ">";
			var tag:RegExp = new RegExp(theRegExp, "g");
			return tag.exec(inText);
		}
		
		static public function findTags(inTag:String, inText:String):ArrayCollection
		{
			var theRegExp:String = "<" + inTag + "(?P<options>[^<>]+)?>(?P<value>[^<>]+)</" + inTag + ">";
			var tag:RegExp = new RegExp(theRegExp, "g");
			var theTags:ArrayCollection = new ArrayCollection;
			var result:Array = tag.exec(inText);
			while (result != null)
			{
				theTags.addItem(result);
				result = tag.exec(inText);
			}
			return theTags;
		}
		
		static public function getHtmlText():com.htmlFilter.text
		{
			var newTextField:com.htmlFilter.text = new com.htmlFilter.text();
			//newTextField.mouseChildren=false;
			newTextField.selectable=true;
			newTextField.condenseWhite=false;
			newTextField.percentWidth = 100;
	
			newTextField.setStyle("paddingLeft", 10);
			newTextField.setStyle("paddingRight", 10);
			newTextField.setStyle("paddingTop", 10);
			newTextField.setStyle("paddingBottom", 10);
			
			return newTextField;
		}
		
		static public function getStyles():StyleSheet
		{
			if (!setStyles)
			{
				var styles:StyleSheet = new StyleSheet;
				
				var h1:Object = new Object();
				h1.fontFamily = "Verdana";
				h1.fontWeight = "bold";
				h1.color = "#000000";
				h1.fontSize = 20;
				h1.leading = 10;

				var h2:Object = new Object();
				h2.fontFamily = "Verdana";
				h2.fontWeight = "bold";
				h2.color = "#333333";
				h2.fontSize = 16;
				h2.leading = 4;

				var a:Object = new Object();
				a.fontFamily = "Verdana";
				a.fontSize = 12;
				a.color = "#0066FF";
				a.textDecoration = "underline";
		
				var para:Object = new Object();
				para.fontFamily = "Verdana";
				para.fontSize = 12;
				para.paddingLeft = 10;
				para.paddingTop = 5;
				para.paddingBottom = 10;

				var htmlTableCaption:Object = new Object();
				htmlTableCaption.fontFamily = "Verdana";
				htmlTableCaption.fontSize = 12;
				htmlTableCaption.borderStyle = "none"
				htmlTableCaption.textAlign = "center";
				htmlTableCaption.fontWeight = "bold"

				styles.setStyle("h1", h1);
				styles.setStyle("h2", h2);
				styles.setStyle("p", para);
				styles.setStyle("a", a);
				styles.setStyle("htmlCelltext", para)
				styles.setStyle("htmlTableCaption", htmlTableCaption);
				styles.setStyle("listItems", para);
				
				setStyles = true;
			}
			
			return styles;
		}
	
	}
}

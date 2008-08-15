package com.htmlFilter
{
	import mx.containers.Canvas;
	import flash.text.StyleSheet;
	
	
	public class htmlTable extends Canvas
	{
		import flash.events.Event;
		import mx.collections.ArrayCollection;
		import mx.core.UIComponent;
		import mx.core.EdgeMetrics;
		import flash.events.MouseEvent;
		import com.htmlFilter.text;
		import mx.containers.HBox;
		import com.htmlFilter.box;
		import com.htmlFilter.optionAndStyles;
		
		private var theRows:ArrayCollection = new ArrayCollection();
		private var currentRow:Number = 0;
		private var theText:String;
		private var theInfo:Object;
		private var styles:StyleSheet;
		
		public function htmlTable (inInfo:Object, inStyles:StyleSheet)
		{
			super();
			
			htmlRow.maxCells = 0;
			styles = inStyles;
			horizontalScrollPolicy="off";
			theInfo = inInfo;
			theInfo.Text = theInfo.Text.replace("</table>", "");
			
			findRows(theInfo.Text);
			    		
    		var foundCaption:Array = optionAndStyles.findTag("caption", theInfo.Text);
			if (foundCaption != null)
			{
				addCaption(foundCaption.value);
			}
			
            for each (var row:Object in theRows)
            {
            	row.fillCells();
            	addChild(row.getDisplay(width));
            }
			
    		var foundReference:Array = optionAndStyles.findTag("reference", theInfo.Text);
			if (foundReference != null)
			{
				addReference(foundReference.value, foundReference.options);
			}
		}
		
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
    
            var vm:EdgeMetrics = viewMetricsAndPadding;
    
            var yOfComp:Number = 0;
            
            var xOfComp:Number = 0;
            
            var toX:Number;
            
            var obj:UIComponent;
            
            var i:int;
            
	        for (i = 0; i < numChildren; i++)
	        {
	            obj = UIComponent(getChildAt(i));
	            obj.move(obj.x, yOfComp);
	            yOfComp = yOfComp + obj.height-1;
	        }        
            
        }
        
        private function findRows(inText:String):void
        {
        	theRows = new ArrayCollection();
        	currentRow = -1;
        	var tags:RegExp = new RegExp("<(?P<tag>[^<>]*)>", "g");
			var result:Array = tags.exec(inText);
			var prevPart:Object;
				 
			while (result != null)
			{
				if (result.tag.substr(0,2) == "tr")
				{
					if (currentRow > -1)
					{
						prevPart = theRows.getItemAt(currentRow);
						prevPart.Text = inText.substring(prevPart.StartIndex, result.index);
					}
					theRows.addItem(new htmlRow(result.index, styles));
        			currentRow++;
					
				}
				else if (result.tag == "/tr")
				{
					prevPart = theRows.getItemAt(currentRow);
					prevPart.Text = inText.substring(prevPart.StartIndex, result.index + result[0].length);
				}
				result = tags.exec(inText);
			}
			
			prevPart = theRows.getItemAt(currentRow);
			if (inText != null)
			{
				prevPart.Text = inText.substring(prevPart.StartIndex, inText.length);
			}
			else
			{
				prevPart.Text = "This table is loading";
			}
        }
        
        private function addCaption(inCaption:String):void
        {
		    var newTextField:text = optionAndStyles.getHtmlText();
			newTextField.setStyle("paddingTop", 5);
			newTextField.htmlText = "<span class='htmlTableCaption'>" + inCaption + "</span>";
			addChild(newTextField);
			newTextField.styleSheet = styles;
        }
        
        private function addReference(inCaption:String, inOptions:String):void
        {
        	var type:String = "text";
        	var showAs:String = "";
        	
        	var theOptions:ArrayCollection = optionAndStyles.findOptions(inOptions);
        	
        	for each (var option:Array in theOptions)
        	{
        		switch (option.optionName)
        		{
        			case "type" :
        				type = option.optionValue;
        				break;
        			case "showAs" :
        				showAs = option.optionValue
        				break;
        		}
        	}
			
			if (type == "webAddress")
			{
				showAs == ""
				?
					inCaption = "Reference : <a href=\"" + inCaption + "\">" + inCaption + "</a>"
				:
					inCaption = "Reference : <a href=\"" + inCaption + "\">" + showAs + "</a>";
			}
			
			addCaption(inCaption);
        }
	}
}

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.UIComponent;
import mx.containers.HBox;
import mx.collections.ArrayCollection;
import mx.containers.Canvas
import flash.text.StyleSheet;
import com.htmlFilter.text;
import com.htmlFilter.optionAndStyles;
import com.htmlFilter.box;

class htmlRow extends EventDispatcher implements IEventDispatcher
{

	public static var maxCells:Number = 0;
	
	private var theStartIndex:Number;
	private var theText:String;
	private var numCells:Number;
	private var styles:StyleSheet;
	
	private var theCells:ArrayCollection = new ArrayCollection;
	private var currentCell:Number;

    public function htmlRow(inIndex:Number, inStyles:StyleSheet)
    {
    	theStartIndex = inIndex;
    	styles = inStyles;
    	theText = null;
    	numCells = 0;
    }

    public function getDisplay(inWidth:Number):UIComponent
    {
		var rowBox:box = new box(box.ROW);
		rowBox.theItems = theCells;
		rowBox.NumItems = numCells;		
		for each (var cell:Object in theCells)
		{
			rowBox.addChild(cell.getDisplay(inWidth))
		}
		return rowBox;
    }
    
    public function fillCells():void
    {
    	for ( var i:Number = 0;i< (maxCells - numCells);i++)
    	{
    		theCells.addItem(new htmlCell(0, numCells+i, styles));
    	}
    }
    
    private function findCells(inText:String):void
    {
    	numCells = 0;
    	theCells = new ArrayCollection();
    	currentCell = -1;
    	var tags:RegExp = new RegExp("<(?P<tag>[^<>]*)>", "g");
		var result:Array = tags.exec(inText);
		var prevPart:Object;
		
		var colspan:Number = 1;
		var pattern:RegExp;
		var foundColspan:Array;
		var foundAlign:Array;
		var align:String = "left";
			 
		while (result != null)
		{
			if (result.tag.substr(0,2) == "td")
			{
				colspan = 1;
				theCells.addItem(new htmlCell(result.index, numCells, styles));
				currentCell++;
				theCells.getItemAt(currentCell).theOptions = optionAndStyles.findOptions(result[0]);
    			numCells += colspan;
			}
			else if (result.tag.substr(0,2) == "th")
			{			
				colspan = 1;
				theCells.addItem(new htmlCell(result.index, numCells, styles, "th"));
				currentCell++;
				theCells.getItemAt(currentCell).theOptions = optionAndStyles.findOptions(result[0]);
				numCells+=colspan;
			}
			else if (result.tag == "/td")
			{
				prevPart = theCells.getItemAt(currentCell);
				prevPart.setText(inText.substring(prevPart.StartIndex, result.index + result[0].length));
			}
			else if (result.tag == "/th")
			{
				prevPart = theCells.getItemAt(currentCell);
				prevPart.setText(inText.substring(prevPart.StartIndex, result.index + result[0].length));
			}
			result = tags.exec(inText);
		}
		
		maxCells = (maxCells > numCells? maxCells : numCells);
		
		prevPart = theCells.getItemAt(currentCell);
		if (inText != null)
		{
			prevPart.setText(inText.substring(prevPart.StartIndex, inText.length));
		}
		else
		{
			prevPart.Text = "This table is loading";
		}
    }
    
    public function get StartIndex ():Number
    {
    	return theStartIndex;
    }
    public function set StartIndex (inIndex:Number):void
    {
    	theStartIndex = inIndex;
    }
    
    public function get Text ():String
    {
    	return theText;
    	
    }
    public function set Text (inText:String):void
    {
    	
    	inText = inText.replace("</tr>", "");
    	theText = inText;
    	findCells(inText);
    }
    
    
        
}

class htmlCell extends EventDispatcher implements IEventDispatcher
{
	private var theStartIndex:Number;
	private var theText:String;
	private var theType:String;
	private var theColspan:Number;
	private var theCellIndex:Number;
	private var styles:StyleSheet;
	private var align:String;
	private var theClass:String;
	
	private var theCells:ArrayCollection = new ArrayCollection;
	private var currentCell:Number;
	
	public var theOptions:ArrayCollection = new ArrayCollection();

    public function htmlCell(inIndex:Number, inCellIndex:Number, inStyles:StyleSheet, inType:String = "td")
    {
    	theStartIndex = inIndex;
    	styles = inStyles;
    	theCellIndex = inCellIndex;
    	theColspan = 1;
    	theType = inType;
    	theText = "";
    	theClass = "";
    }
    
    public function getDisplay(inWidth:Number):UIComponent
    {
    	setOptions();
    	var newTextField:text = optionAndStyles.getHtmlText();
		
		newTextField.htmlText = "<p align='" + align + "'>" + theText + "</p>";
		
		var cellBox:box = new box(box.CELL);		
		
		switch (theType)
		{
			case "td" :
				cellBox.styleName = "tableTD" + theClass;
				break;
			case "th" :
				cellBox.styleName = "tableTH" + theClass;
				break;
			default :
				cellBox.styleName = "box" + theClass;
				break;
		}
		
		if (theClass == "")
		{
		
			if (theCellIndex != 0)
			{
				cellBox.setStyle("borderSides", "left");
			}
			else
			{
				cellBox.setStyle("borderStyle", "none");
			}
		}
		cellBox.addChild(newTextField)
		newTextField.styleSheet = styles;
		
		return cellBox;
    	
    }
    
    public function setText(inText:String):void
    {
    	switch (theType)
    	{
    		case "td" :
    			theText = inText;
    			break;
    		case "th" :
    			theText = "<b>" + inText + "</b>";
    			break;
    		default :
    			trace("can't set the text for type : " + theType);
    			break;
    	}
    }
    
    private function setOptions():void
    {
		for each (var option:Array in theOptions)
		{
			switch (option.optionName)
			{
				case "align" :
					align = option.optionValue;
					break;
				case "colspan" :
					theColspan = option.optionValue;
					break;
				case "class" :
					theClass = option.optionValue;
					break;
			}
		}	
	}
    
    public function get StartIndex ():Number
    {
    	return theStartIndex;
    }
    public function set StartIndex (inIndex:Number):void
    {
    	theStartIndex = inIndex;
    }
    
    public function set Align(inAlign:String):void
    {
    	align = inAlign;
    }
    
    
    public function get Text ():String
    {
    	return theText;
    	
    }
    
    public function get Type ():String
    {
    	return theType;
    }
    
    public function get Colspan ():Number
    {
    	return theColspan;
    }
    
    public function set Text (inText:String):void
    {
    	
    	inText = inText.replace("<td>", "");
    	inText = inText.replace("</td>", "");
    	theText = inText;
    }
    


}


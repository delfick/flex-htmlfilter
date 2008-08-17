

/*  
#  box.as
#  
#  Author : Stephen Moore - delfick755@gmail.com
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
*/

package com.htmlFilter
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mx.core.UIComponent;
	import mx.containers.Canvas;
	import mx.collections.ArrayCollection;
	
	public class box extends Canvas
	{
		public static const ROW:String = "row";
		public static const CELL:String = "cell";
		public static const TEXT:String = "text";
		
		public var theItems:ArrayCollection;
		
		private var type:String;
		private var numItems:Number;
		
		public function box(inType:String)
		{
			type = inType;
			horizontalScrollPolicy="off";
			verticalScrollPolicy="off";
			switch (type)
			{
				case ROW :
					styleName = "tableRow";
					percentWidth=100;
					break;
				case CELL :
					//handled in htmlTable.as -> htmlCell -> getDisplay()
					percentWidth=100;
					break;
				case TEXT :
					styleName = "plain";
					percentWidth=100;
					setStyle("borderStyle", "none");
					break;
			}
			
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
		    super.updateDisplayList(unscaledWidth, unscaledHeight);
		    
		    var xOfComp:Number = 0;
		    
		    var obj:UIComponent;
		    
		    var i:int;
		    
		    switch (type)
		    {
		    	case TEXT :
		    	case CELL :
		    
					for (i = 0; i < numChildren; i++)
					{
						obj = UIComponent(getChildAt(i));
						obj.setActualSize(obj.width, obj.height+10);
					}
					for (i = 0; i < numChildren; i++)
					{
						obj = UIComponent(getChildAt(i));
						obj.move(xOfComp, obj.y);
						xOfComp = xOfComp + obj.width;
					}  
					break;
					
		        case ROW :
		        
		        	var colspan:Number;
        
					if (numChildren > numItems)
					{
						numItems = numChildren;
					}
				
				
					for (i = 0; i < numChildren; i++)
					{
						obj = UIComponent(getChildAt(i));
						colspan = theItems.getItemAt(i).Colspan
						obj.setActualSize((unscaledWidth / numItems)*colspan, unscaledHeight);
					}
					for (i = 0; i < numChildren; i++)
					{
						colspan = theItems.getItemAt(i).Colspan
						obj = UIComponent(getChildAt(i));
						obj.move(xOfComp, obj.y);
						xOfComp = xOfComp + obj.width;
					}    
				
					break; 
		    } 
		    
		}
		
		public function set NumItems (inNum:Number):void
		{
			numItems = inNum;
		}
	}
}

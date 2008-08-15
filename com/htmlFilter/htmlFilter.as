package com.htmlFilter
{
#  htmlFilter.as
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

	public class htmlFilter
	{
	
		import flash.text.StyleSheet;
		import mx.collections.ArrayCollection;
		import com.htmlFilter.optionAndStyles;
		
		private var tagHistory:ArrayCollection;
		
		private var indentLevel:Number;
		
		private var lists:ArrayCollection;
		private var currentList:Object;		
		
		private var doBr:Boolean;		
		
		public function filterContent(theData:String):String
		{
			indentLevel = 0;
			lists = new ArrayCollection();
			tagHistory = new ArrayCollection();
			doBr = false;
			tagHistory = new ArrayCollection();
			var htmlTag:RegExp = new RegExp("<(?P<tag>[^<>]*)>", "g");
			theData =  theData.replace(/\t|\n|\r/g, "");
			theData =  theData.replace(/  /g, " ");
			return theData.replace(htmlTag, replaceHTML);
		}

		private function replaceHTML(found:String, tag:String, index:int, other:int):String
		{
			var theReturn:String = "";
			tagHistory.addItem(found);
			var lastTag:String = "";
			if (tagHistory.length-2 > 0)
			{
				 lastTag = String(tagHistory.getItemAt(tagHistory.length-2));
			}
			
			if (foundStartHeader(tag))
			{
				theReturn = "<p class='" + tag.substr(0,2) + "'>";
			}
			else if (foundEndHeader(tag))
			{
				theReturn = "</p>";
			}
			else if (foundStartP(tag))
			{
				lastTag.substr(0,3) == "</h" && lastTag.length == 5
				?
					theReturn = "\n<p>"
				:
					theReturn = "<p>";
			}
			else if (foundEndP(tag))
			{
				theReturn = "</p>\n";
			}
			else if (foundListStart(found))
			{
				theReturn = "<span class='listItems'>";
				if (indentLevel == 1)
				{
					if (lastTag != "</p>")
					{
						theReturn += "\n";
					}
				}
			}
			else if (foundListItem(found))
			{
				if (lastTag == "</li>") 
				{ 
					theReturn += "\n"; 
					if (currentList.doBr)
					{
						theReturn += "\n";
					}
				}
				else if (doBr) 
				{ 
					theReturn += "\n"; 
					doBr = false;
				}
				var indentTo:Number = 10 + indentLevel*30 + (indentLevel-1)*10;
				theReturn += "<textformat blockindent='" + indentTo + "'" +
							 "indent='" + currentList.indent + "' " +
							 "tabstops='[" + (indentTo) +"]'>" + 
							 currentList.currentIndex + "\t";
			}
			else if (foundEndListItem(found))
			{
				theReturn = "</textformat>";
				
			}
			else if (foundEndList(found))
			{
				theReturn = "</span>";
				if (indentLevel == 0)
				{
					theReturn = "</span>\n\n";
				}
				
			}
			else
			{
				theReturn = found;
			}
			return theReturn;
			
		}		
		
		private function foundListStart (found:String):Boolean
		{
			switch (found.substr(1,2))
			{
				case "ul" :
				case "ol" :
					indentLevel++;
					if (indentLevel > 1)
					{
						doBr = true;
					}
					lists.addItem(new htmlList(found));
					currentList = lists.getItemAt(lists.length-1);
					
					var theOptions:ArrayCollection = optionAndStyles.findOptions(found);
					
					for each (var option:Array in theOptions)
					{
						switch (option.optionName)
						{
							case "doLineBreaks" :
								currentList.doBr = Boolean(option.optionValue);
								break;
						}
					}
					return true;
					break;
				default :
					return false;
					break;
			}
		}
		
		private function foundListItem (found:String):Boolean
		{
			switch (found)
			{
				case "<li>" :
					return true;
					break;
				default :
					return false;
					break;
			}
		}

		private function foundEndListItem (found:String):Boolean
		{
			switch (found)
			{
				case "</li>" :
					return true;
					break;
				default :
					return false;
					break;
			}
		}
		
		private function foundEndList (found:String):Boolean
		{
			switch (found)
			{
				case "</ul>" :
				case "</ol>" :
					indentLevel--;
					if (lists.length > 1)
					{
						lists.removeItemAt(lists.length-1);
						currentList = lists.getItemAt(lists.length-1);
					}
					return true;
					break;
				default :
					return false;
					break;
			}
		}
		
		private function foundStartHeader (tag:String):Boolean
		{
			return tag.substr(0,1) == "h" && tag.length == 2;
		}
		
		private function foundEndHeader (tag:String):Boolean
		{
			return tag.substr(0,2) == "/h" && tag.length == 3;
		}
		
		private function foundStartP (tag:String):Boolean
		{
			return tag.substr(0,1) == "p" && tag.length == 1;
		}
		
		private function foundEndP (tag:String):Boolean
		{
			return tag.substr(0,2) == "/p";
		}
		
		
	}
}

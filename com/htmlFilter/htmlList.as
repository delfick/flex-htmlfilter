package com.htmlFilter
{
	public class htmlList
	{
		import mx.collections.ArrayCollection;
		import com.htmlFilter.optionAndStyles;
	
		private var ender:String;
		
		private var theIndent:Number;
		
		private var starter:String;
		
		private var alpha:Array = ['a', 'b' , 'c' , 'd' , 'e' , 'f' , 'g' , 'h' , 'i' , 'j' , 'k' , 'l' , 'm' , 'n' , 'o', 'p' , 'q' , 'r' , 's' , 't' , 'u' , 'v' , 'w' , 'x' , 'y' , 'z'];
		
		private var out:String = "";
		
		private var theType:String;
		
		private var theCurrentIndex:Number;
		
		private var alphaIndex:ArrayCollection = new ArrayCollection;
		
		private var olType:String;
		
		private var doLineBreak:Boolean = false;
		
			
		
		public function htmlList(inFound:String)
		{
			starter = "";
			theIndent = -30;
			
			if (inFound == "<ul>")
			{
				theType = "ul";
				ender = "";
				theIndent = -20;
			}
			else if (inFound.substr(1,2) == "ol")
			{
				ender = ".";
				theType = "ol";
				olType = "1";
				theCurrentIndex = 0;
			}
			
			var theOptions:ArrayCollection = optionAndStyles.findOptions(inFound);
			
			for each (var option:Array in theOptions)
			{
				switch (option.optionName)
				{
					case "type" :
						if (option.optionValue != "1")
						{
							olType = option.optionValue;
							alphaIndex.addItem(-1)
						}
						break;
					case "starter" :
						starter = option.optionValue;
						break;
					case "ender" :
						ender = option.optionValue;
						break;
				}
			}
			
		}
		
		public function get type ():String
		{
			return theType;
		}
		
		public function get currentIndex ():String
		{
			if (theType == "ol")
			{
				switch (olType)
				{
					case "1" :
						theCurrentIndex++;
						return starter + theCurrentIndex + ender;
						break;
					case "i" :
						theCurrentIndex++;
						return starter + arab2Rom(theCurrentIndex) + ender;
						break;
					case "I" :
						theCurrentIndex++;
						return starter + arab2Rom(theCurrentIndex).toUpperCase() + ender;
						break;
					case "a":
					case "A" :
						alphaIndex[0]++;
						if (alphaIndex.getItemAt(0) > 25)
						{
							incrementNextAlpha(0);
						}
						out = "";
						for (var i:Number = 0;i<alphaIndex.length;i++)
						{
							out = alpha[alphaIndex.getItemAt(i)]+out;
						}
						if (olType == "A")
						{
							out = out.toUpperCase();
						}
						return starter + out + ender;
						break;
					default :
						theCurrentIndex++
						return starter + "?" + ender;
						break;
				}
				
			}
			else
			{
				return starter + "•" + ender;
			}
		}
		
		private function incrementNextAlpha (inIndex:Number):void
		{
			alphaIndex.setItemAt(0, inIndex);
			if (alphaIndex.length == inIndex+1)
			{
				alphaIndex.addItem(0);
			}
			else
			{
				var currentValue:Number = Number(alphaIndex.getItemAt(inIndex+1));
				alphaIndex.setItemAt(currentValue+1, inIndex+1) ;
				if (alphaIndex.getItemAt(inIndex+1) > 25)
				{
					incrementNextAlpha(inIndex+1);
				}
			}
		}
		
		private function arab2Rom(inNum:Number):String
		{
			var arabic:Array = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
			var roman:Array = ['m','cm' ,'d' ,'cd' ,'c' ,'xc' ,'l' ,'xl' ,'x' ,'ix' ,'v' ,'iv' ,'i'];
			var i:Number = 0;
			out = "";
			
			while (inNum > 0)
			{
				while (inNum >=arabic[i])
				{
					inNum -= arabic[i];
					out += roman[i];
				}
				i++;
			}
			return out;
		}
		

		public function set doBr (inDoBr:Boolean):void
		{
			doLineBreak = inDoBr;
		}
		public function get doBr ():Boolean
		{
			return doLineBreak;
		}
		
		public function get indent ():Number
		{
			return theIndent;
		}
		
	}
}
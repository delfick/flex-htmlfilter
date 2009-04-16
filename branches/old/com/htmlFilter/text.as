package com.htmlFilter
{
    import mx.controls.Text;
    import flash.text.StyleSheet;

    public class text extends Text 
    {

        public function text() 
        {
            super();
        }

        public function get styleSheet() : StyleSheet 
        {
             return textField.styleSheet;
        }

        public function set styleSheet(value : StyleSheet) : void 
        {	
           textField.styleSheet = value;
        }
    }
}


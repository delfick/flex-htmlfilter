

#include "misc.h"

package com.htmlFilter
{
    import mx.controls.Text;
    import flash.text.StyleSheet;
	import com.htmlFilter.debug;

    public class text extends Text 
    {

        public function text() 
        {
            super();
        }
        
        ppVarGetSet(styleSheet, textField.styleSheet, StyleSheet);
    }
}


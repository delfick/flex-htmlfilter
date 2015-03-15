Flex htmlfilter
===============

By default, Flash only supports a small subset of HTML in htmlText fields
(`Reference <http://livedocs.adobe.com/flex/3/html/help.html?content=textcontrols_04.html>`_)

* Anchor tag (``<a>``)
* Bold tag (``<b>``)
* Break tag (``<br>``)
* Font tag (``<font>``)
* Image tag (``<img>``)
* Italic tag (``<i>``)
* List item tag (``<li>``)
* Paragraph tag (``<p>``)
* Text format tag (``<textformat>``)
* Underline tag (``<u>``)

Flex-htmlFilter can be utilised to extend the HTML support of htmlText
fields by enabling the use of:

* Unordered list tag (``<ul>``)
* Ordered list tag (``<ol>``)
* Table tag (``<table>``)
* Table row tag (``<tr>``)
* Table column tag (``<td>``)
* Table header column (``<th>``)
* Table caption tag (``<caption>``)
* Heading tags (``<h1-6>``)

As well as this, it allows the use of some "custom" tags and some
custom attributes of the above tags.

See http://flex-htmlfilter.googlecode.com/svn/trunk/base/com/htmlFilter/Supported%20Tags%20and%20Attributes
for a full list of the supported tags and attributes.
(when I have time, I'll make into a wiki page and update it)

An *old* (look below for the new one) interactive example can be found at
http://stephen-m.appspot.com/htmlFilter
(Note *this is the old version*, keep reading this page!)

New Version
-----------

Since April 16 2009, trunk contains a new version of flex-htmlfilter.
Unfortunately I have little time to document what has been added and changed,
however I do plan to do this in the future.

However, one major change is the use of preprocessing in the code.

Please refer to this `wiki page <http://code.google.com/p/flex-htmlfilter/wiki/CompilingUnderWindows>`_
for more details.

For now, an online demo can be found here http://stephen-m.appspot.com/htmlFilterNew

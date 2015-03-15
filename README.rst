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

An *old* (look below for the new one) interactive example can be found at
http://stephen-m.appspot.com/htmlFilter
(Note *this is the old version*, keep reading this page!)

New Version
-----------

Since April 16 2009, trunk contains a new version of flex-htmlfilter.
Unfortunately I have little time to document what has been added and changed,
however I do plan to do this in the future.

However, one major change is the use of preprocessing in the code.

For now, an online demo can be found here http://stephen-m.appspot.com/htmlFilterNew

Compiling Under Windows
-----------------------

What is essentially the second version of flex-htmlfilter uses a project called
`flex2cpp <http://sourceforge.net/projects/flex2cpp>`_ to provide preprocessing on the code.

In most distributions of linux, the required software should be installed and
all you have to do is cd to the directory where you have flex-htmlfilter and run "make"

In Windows however, you first have to put in some effort.

Fortunately most of the effort has been taken care of by the author of flex2cpp
with an installation script that he has created.

#. Download this: http://sourceforge.net/project/downloading.php?group_id=193742&filename=installer103.zip&a=27834447

#. Unzip that anywhere you like.
   For the purposes of these instructions, I'll assume you unzipped it into ``C:/installer``.
   You can replace ``c:/installer`` with whatever directory you chose

#. Open the windows cmd prompt (start menu -> run box -> type "cmd" and press enter)
   Then type ``cd C:/installer`` and press enter.

   Note that if you ``cd`` into a different drive than your cmd prompt is currently
   in then you have to change the drive by typing the letter of that drive
   followed by a colon and pressing enter.

   So say you need to cd into E: and you are in C:, then type "``E:``" and press enter.

#. Type "``download.bat``", press enter and wait

#. Type "``install.bat C:/MinGW``", press enter and wait

   Please note that you should only install this to C:/MinGW unless you know
   what you are doing (from documentation of mingw)

#. Right click on "My Computer" -> properties -> advanced tab -> "Environment Variables" at the bottom
   -> "System Variables" pane -> choose the "Path" variable and click edit

#. Append to the list "``C:/MinGw/bin``" (items are seperated with a semi-colon "``;``")
   and click OK.

#. Edit the PATHEXT variable (should be below "Path") and add "``.exe``" to the end of it.

#. Keep pressing ok until all the dialog boxes are gone

#. Open up a new cmd prompt, cd to where you have flex-htmlfilter and type "``make``"
   and it should magically work :)


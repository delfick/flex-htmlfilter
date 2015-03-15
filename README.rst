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

Demos
-----

The new demo: http://stephen-m.appspot.com/htmlFilterNew

The old demo: http://stephen-m.appspot.com/htmlFilter

New version
-----------

Since April 16 2009, trunk contains a new version of flex-htmlfilter.
Unfortunately I have little time to document what has been added and changed

However, one major change is the use of preprocessing in the code.

Problems solved
---------------

There are two main problems solved by flex-htmlfilter:

* Html elements that can be faked using the built-in html tags
* Html elements that cannot be faked using the built-in html tags

The first problem is solved with HtmlFilter, which will go through the html
you give it and covert what it can such that the resulting text can be used
in a normal ``mx.controls.Text`` component and be able to display
lists and headers correctly.

To solve the second problem flex-htmlfilter provides the ``htmlFilter.htmlText`` component.

This is a `mx.containers.Canvas` component that will tile a bunch of other
components to represent the tables, images and text in the html you give it.

Note that htmlText will not automatically use HtmlFilter and that usage of this
class is up to the programmer.

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

Implemented Tags
----------------

Flex htmlfilter supports any tag already supported by ``flash.text.htmlText``.
It also supports the following:

<ul>
  Unordered list. These support ``<li>`` child tags and nested lists.

<ol>
  Ordered list. These support ``<li>`` child tags and nested lists.

  They also have a ``type`` attribute whose value change the type of numbering
  used by the list. Supported values are '1', 'a', 'A', 'i' and 'I'.

<table>
  Tables can't be nested.

  They support ``<caption>`` and ``<tr>`` child tags.

  <caption>
    Will put the enclosed string at the top of the table in the middle

  <tr>
    Starts a new row

    These support ``<td>`` and ``<th>`` child tags.

    <td>
      Starts a new cell in the row with a style defined by "tableTD".

      They support any child tags except ``<table>``.

      They support a ``colspan`` attribute which says what width it should
      take in terms of number of cells.

    <th>
      Starts a new cell with a style defined by "tableTH".

      It supports the same child tags and attributes as ``<td>``.

<h``x``>
  Where x is a number to specify the level of header

  You must have a css class called "h``x``" defined for the header to be
  displayed differently to normal text.

Custom Tags
-----------

<Reference>
  This can be used under a ``<table>`` and will create a line below the table.

  It does not support any child tags.

  It does support ``type`` and ``showas`` attributes.

  ``type`` attribute
    Allows you to choose the type of reference.

    Options are "" or "webAddress"

    If anything other than webAddress is defined as the type then it will only
    display what is defined by the Reference tag

    If the type is webAdress, then it will display "Reference : <<link>>" where
    the link will point to what is defined by the Reference tag

  ``showas`` attribute
    If the type is "webAddress", then the reference will appear as a link
    with the text defined by ``showas``.

    An example would be::

        <Reference type="webAddress" showAs"google">www.google.com</Reference>

    Which will show the reference tag as "Reference : google" where google
    is a link that points to www.google.com.

<image>
  Creates an image separate to text and tables.

  It does not support any child tags.

  It does support ``src``, ``cache`` and ``width`` attributes.

  ``src`` attribute
    Path to the image to be used.

  ``cache`` attribute
    Cache name for the image

    See `SuperImage <http://www.quietlyscheming.com/blog/2007/01/23/some-thoughts-on-doubt-on-flex-as-the-best-option-orhow-i-made-my-flex-images-stop-dancing/>`_
    for more information on this

    A value of "null" will mean the image isn't cached.

  ``width`` attribute
    Specifies the width of the image in pixels.

Custom Attributes
-----------------

For the <ul> and <ol> tags
  doLineBreaks
    If "true" then there will be a line break between list items.

    If "false", there won't be a line break between list items.

    Default is "false".

  starter
    Defines what will appear before the numbering/bullets for the list.

  ender
    Defines what will appear before the numbering/bullets for the list.

  An Example of starter and ender would be if you wanted every number/bullet
  in the list to be enclosed in brackets.

  You would use <ol starter="(" ender=")"> to result in::

      (1) ...
      (2) ...

For the <td> tag
  class
    Will use the css style as defined by "tableTD<<className>>"
    where <<className>> is the classname defined by the class attribute.

For the <th> tag
  class
    Will use the css style as defined by "tableTH<<className>>"
    where <<className>> is the classname defined by the class attribute.

How HtmlFilter Works
--------------------

The ``com.htmlFilter.htmlFilter`` class has a ``filterContent`` function which accepts
a string (and optionally, a Hash of "special" tags).

It will then use regular expressions to replace all newlines and tags with an
empty string and ensure that there is appropriate space before elements
after this replacement.

Then it will find all tags and replace them as appropriate using the ``replaceHtml``
function with a regular expression. This ``replaceHtml`` works by returning a
modified version of each tag it finds.

So for each tag, ``found`` represents the whole tag and ``tag`` represents the name of the tag.

For example, with ``<p>`` or ``</p>`` or ``<p class="blah">``, the tag is ``p`` and ``extra``
is the attributes given to the tag.
i.e. in ``<p class="blah">``, the ``extra`` is ``class="blah"``.

Fist it will look for a "special" class. These are classes that will be
replaced with special mxml containers if the htmlText component is used.

For example, as provided in flex-htmlfilter, the "sp" class.

HtmlText will expect a ``<sp>content here</sp>`` to be able to insert the sp class
into the canvas.

HtmlFilter will look for anything that has a class of any of these classes
and swap the class and the tag.

For example, say we have ``<p class="sp">blablablabla</p>`` then htmlFilter will
find that the "sp" is in the ``knownClasses`` and replace the tag with
``<sp class="p">blablablabla</sp>``.

This is purely an alternative to specifying the element with the sp tag.

It will then continue, and using the macros defined at the top of the file,
will look for elements that are headings, paragraphs or lists.

If it finds a heading (i.e. a tag that is "h" followed by a number)
it will replace it with a paragraph with a class of the heading.

For example, ``<h1>stuff</h1>`` is replaced with ``<p class="h1">stuff</p>``.

We can then create classes that mimic the different headings and apply them
to the text field that is used to display the html.

If it finds a ``<p>`` and the last element it found was a heading, then a newline
is prepended, otherwise it is left alone.

When it finds a list, then we create a ``com.htmlFilter.htmlList`` and set it as
``currentList`` and use this for every list item we find.
(It will create a stack holding these lists, so we can nest lists).

These list objects are then responsible for determining the number/bullet
of each item in the list.

Each list is then represented using spans and textformats::

    <ul>
      <li>blah</li>
    </ul>

Is converted into::

    <span class='listItems'>
      <textformat blockindent='40' indent='-20' tabstops='[40]'>• stuff</textformat>
    </span>

Every time we nest a list, it will change the amount for ``blockindent``,
``indent`` and ``tabstops`` such that each item will indent appropriately.

A more complicated example::

    <ul>
      <li>stuff
        <ol ender=".">
          <li>one</li>
          <li>two
            <ul>
              <li>hello</li>
              <li>there</li>
            </ul>
          </li>
        </ol>
      </li>
    </ul>

will convert into::

  <span class='listItems'>
    <textformat blockindent='40' indent='-20' tabstops='[40]'>• stuff <span class='listItems'>
    <textformat blockindent='80' indent='-30' tabstops='[80]'>1.    one</textformat>
    <textformat blockindent='80' indent='-30' tabstops='[80]'>2.    two <span class='listItems'>
    <textformat blockindent='120' indent='-20' tabstops='[120]'>•   hello</textformat>
    <textformat blockindent='120' indent='-20' tabstops='[120]'>•   there</textformat>
  </span></textformat></span></textformat></span>

How HtmlText works
------------------

Using the ``commitProperties`` and ``updateDisplayList`` functions that are
called as part of Flex `UIComponents <http://livedocs.adobe.com/flex/3/html/help.html?content=ascomponents_advanced_3.html>`_
this component will vertically stack all of it's children.

The children of the component are created after it has been supplied some html.
It does this by looking through the html for tags and creating children as it goes.

There are two phases to this process:

Finding (the findParts function)
  It will go through the provided text and add objects to a list where each
  object represents a "part" of the canvas.

  It does this by looking for tags. When it finds one it knows about it will set
  the Text of the previous part to the text that exists between the last tag
  and one it just found; followed by adding a new part for the tag it just found.

Adding (the addNewItems function)
  It will go through all the parts and depending on the type of the part it will
  add a new child to the canvas.

  Text parts are represented with a ``com.htmlFilter.box`` class
  with a ``com.htmlFilter.Text`` component inside
  (created using the ``ppCreatePaddedHtmlText`` macro as defined in ``include/misc.h``)

  Tables & images are represented by a ``com.htmlFilter.objectWrapper`` class.

How ObjectWrapper works
-----------------------

The objectWrapper is used to put something in the middle.

It works by making a box that contains three boxes, each next to each other.

The first and last box are of the same width and such that the sum of the widths
of the boxes is the width of the parent container.
The box in the middle has the object that is being wrapped.

So, for example, say the object in the middle is a ``com.htmlFilter.htmlTable``
of width 20 and the width of the parent container (say a ``com.htmlFilter.htmlText``)
is 100, then the two boxes either side of the table will be 40 each.

How HtmlTable works
-------------------

HtmlTable works in a similar way to HtmlText,
except it finds rows and cells and uses the private classes as defined
in ``com.htmlFilter.htmlTable.as``.


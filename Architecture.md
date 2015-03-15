#A brief overview of how flex-htmlfilter works

# Problems solved #

There are two main problems solved by flex-htmlfilter:
  * Html elements that can be faked using the built-in html tags
  * Html elements that cannot be faked using the built-in html tags

The first problem is solved with HtmlFilter, which will go through the html you give it and covert what it can, such that the resulting text can be used in a normal mx.controls.Text component and be able to display lists and headers correctly.

To solve the second problem, flex-htmlfilter provides the htmlFilter.htmlText component which is a `mx.containers.Canvas` component that will tile a bunch of other components to represent the tables, images and text in the html you give it. Note that htmlText will not automatically use HtmlFilter and that usage of this class is up to the programmer.

# How HtmlFilter Works #

the `com.htmlFilter.htmlFilter` class has a `filterContent` function which accepts a string (and optionally, a Hash of "special" tags, but more on that later).

It will then use regular expressions to replace all newlines and tags with an empty string and ensure that there is appropriate space before elements after this replacement.

Then, it will find all tags and replace them as appropiate using the `replaceHtml` function with a regular expression. This `replaceHtml` works by returning a modified version of each tag it finds.

So, for each tag, `found` represents the whole tag, `tag` represents the name of the tag. So for `<p>` or `</p>` or `<p class="blah">`, the tag is `p` and `extra` is the attributes given to the tag. For Example, in `<p class="blah">`, the `extra` is ` class="blah"`.

Fist it will look for a "special" class. These are classes that will be replaced with special mxml containers if the htmlText component is used. For example, as provided in flex-htmlfilter, the "sp" class. HtmlText will expect a `<sp>content here</sp>` to be able to insert the sp class into the canvas. HtmlFilter will look for anything that has a class of any of these classes and swap the class and the tag.

For example, say we have `<p class="sp">blablablabla</p>`, then htmlFilter will find that the "sp" is in the knownClasses (assuming you've supplied the hash when you invoked `filterContent`) and replace the tag with `<sp class="p">blablablabla</sp>`. This is purely an alternative to specifying the element with the sp tag.

It will then continue, and using the macros defined at the top of the file, will look for elements that are headings, paragraphs or lists.

If it finds a heading (i.e. a tag that is "h" followed by a number), it will replace it with a paragraph with a class of the heading. For example, `<h1>stuff</h1>` is replaced with `<p class="h1">stuff</p>`. We can then create classes that mimic the different headings and apply them to the text field that is used to display the html.

If it finds a `<p>` and the last element it found was a heading, then a newline is prepended, otherwise it is left alone.

When it finds a list, then we create a `com.htmlFilter.htmlList` and set it as `currentList` and use this for every list item we find. (It will create a stack holding these lists, so we can nest lists).

These list objects are then responsible for determining the number/bullet of each item in the list.

Each list is then represented using spans and textformats.

For example,

```
<ul>
  <li>blah</li>
</ul>
```

is converted into

```
<span class='listItems'>
	<textformat blockindent='40' indent='-20' tabstops='[40]'>•	stuff</textformat>
</span>
```

Every time we nest a list, it will change the amount for `blockindent`, `indent` and `tabstops` such that each item will indent appropriately.

A more complicated example:

```
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
```

will convert into

```
<span class='listItems'>
    <textformat blockindent='40' indent='-20' tabstops='[40]'>•	stuff <span class='listItems'>
    <textformat blockindent='80' indent='-30' tabstops='[80]'>1.	one</textformat>
    <textformat blockindent='80' indent='-30' tabstops='[80]'>2.	two <span class='listItems'>
    <textformat blockindent='120' indent='-20' tabstops='[120]'>•	hello</textformat>
    <textformat blockindent='120' indent='-20' tabstops='[120]'>•	there</textformat>
</span></textformat></span></textformat></span>
```

# How HtmlText works #

Using the `commitProperties` and `updateDisplayList` functions that are called as part of Flex UIComponents (http://livedocs.adobe.com/flex/3/html/help.html?content=ascomponents_advanced_3.html), this component will vertically stack all of it's children.

The children of the component are created after it has been supplied some html. It does this by looking through the html for tags and creating children as it goes.

There are two phases to this process:
  * Finding
  * Adding

In the first phase (the `findParts` function), it will go through the provided text and add objects to a list, where each object represents a "part" of the canvas. It does this by looking for tags. When it finds one it knows about, it will set the Text of the previous part to the text that exists between the last tag and one it just found; followed by adding a new part for the tag it just found.

In the second phase (the `addNewItems` function), it will go through all the parts and depending on the type of the part, it will add a new child to the canvas. Text parts are represented with a `com.htmlFilter.box` class with a `com.htmlFilter.Text` component inside (created using the `ppCreatePaddedHtmlText` macro as defined in `include/misc.h`); and tables & images are represented by a `com.htmlFilter.objectWrapper` class.

# How ObjectWrapper works #

The objectWrapper is used to put something in the middle.

It works by making a box that contains three boxes, each next to each other. The first and last box are of the same width, and such that the sum of the widths of the boxes is the width of the parent container. The box in the middle has the object that is being wrapped.

So, for example, say the object in the middle is a `com.htmlFilter.htmlTable` of width 20 and the width of the parent container (say a `com.htmlFilter.htmlText`) is 100, then the two boxes eitherside of the table will be 40 each.

# How HtmlTable works #

HtmlTable works in a similar way to HtmlText, except it finds rows and cells and uses the private classes as defined in `com.htmlFilter.htmlTable.as`.

# Flexibility #

Each of these things have a range of options and little things they do to ensure everything looks good. Unfortunately I don't have the time atm to fully explain all these things, but hopefully the above is enough to get you started in understanding the code when you read it.

Have fun :)
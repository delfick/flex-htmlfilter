What is essentially the second version of flex-htmlfilter uses a project called [flex2cpp](http://sourceforge.net/projects/flex2cpp) to provide preprocessing on the code.

Whilst I haven't used it much, it is in there and it would be a pain to create a version without it.

Fortunately it can be compiled on both windows and linux.

In most distributions of linux, the required software should be installed and all you have to do is cd to the directory where you have flex-htmlfilter and run "make"

In Windows however, you first have to put in some effort.

Fortunately most of the effort has been taken care of by the author of flex2cpp with an installation script that he has created.

# Compiling under Windows #

1. download this : http://sourceforge.net/project/downloading.php?group_id=193742&filename=installer103.zip&a=27834447

2. unzip that anywhere you like. for the purposes of these instructions, I'll assume you unzipped it into `C:/installer`. You can replace `C:/installer` with whatever directory you chose

3. open windows cmd prompt (start menu -> run box -> type "cmd" and press enter) and cd into the directory where you unzipped the installer
  * To do this type "`cd C:/installer`" and press enter
  * Something annoying about windows to note, if you cd into a different drive than the cmd prompt is already in, then you have to change the drive by typing the letter of that drive followed by a colon and press enter. So say you need to cd into E: and you are in C:, then type "`E:`" and press enter.

4. type "`download.bat`", press enter and wait

5. type "`install.bat C:/MinGW`", press enter and wait
  * Please note that you should only install this to C:/MinGW unless you know what you are doing (from documentation of mingw)

6. right click on "My Computer" -> properties -> advanced tab -> "Environment Variables" at the bottom -> "System Variables" pane -> choose the "Path" variable and click edit

7. Append to the list "`C:/MinGw/bin`" (items are seperated with a semi-colon "`;`"), then click ok

8. edit the PATHEXT variable (should be below "Path") and add "`.exe`" to the end of it

9. keep pressing ok until all the dialog boxes are gone

10. open up a new cmd prompt, cd to where you have flex-htmlfilter and type "`make`" and it should magically work :)
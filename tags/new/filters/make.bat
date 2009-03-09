@echo off
echo Build the cpp output filter tool.
echo VERY simple tool, but slightly more stateful than sed would do.
REM GNU/MinGW tools
rem gcc -o cppfilter.exe cppfilter.c
rem 
REM MSVC/Dev Studio tools
REM cl cppfilter.c
REM Watcom tools
REM cl cppfilter.c
REM Clean up and put the filter where it can be found
REM 
REM Make the 'start' clone used to get around nasty IDE behavior
cl start.c shell32.lib


@echo off

setlocal
set listpath=./src/mylib
set whitelist=whitelist-obfuscate.h
set blacklist=auto-obfuscate.h 

if exist %listpath%\%whitelist% goto SkipIt
	echo White list generation will take a few minutes...
	echo It only needs to be run once.
	echo White list generation is extra time-consuming in Windows because we 
	echo can't use 'find', and 'xargs' breaks the limited Windows pipes.
	echo // A white list of symbols defined by Flex which we should not clobber. > %listpath%\%whitelist%
	echo // Generated with 'make whitelist' >> %listpath%\%whitelist%
	nmake /NOLOGO /S /f nmake.mak CFG=release whitelist >> %listpath%\%whitelist% 
	echo. >> %listpath%\%whitelist%
:SkipIt

echo // Disable blackist temporarily > %listpath%\%blacklist%
nmake /NOLOGO /S /f nmake.mak CFG=release prettyprint=true CLIFLAGS=-DNO_OBFUSCATE all
echo // A list of application-defined symbols to obfuscate. > %listpath%\%blacklist%
echo // Generated with 'make obfuscate' >> %listpath%/%blacklist%
nmake /NOLOGO /S /f nmake.mak CFG=release obfuscate >> %listpath%\%blacklist%
echo // Undefine any symbols the same as system calls >> %listpath%\%blacklist%
echo #include "%whitelist%" >> %listpath%\%blacklist%
echo. >> %listpath%\%blacklist%

nmake /NOLOGO /S /f nmake.mak CFG=release all 
nmake /NOLOGO /S /f nmake.mak CFG=profile
nmake /NOLOGO /S /f nmake.mak CFG=debug
endlocal


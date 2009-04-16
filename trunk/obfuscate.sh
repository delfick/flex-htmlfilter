#!/bin/bash
listpath=./src/mylib
whitelist=whitelist-obfuscate.h
blacklist=auto-obfuscate.h 

if [ ! -f $listpath/$whitelist ] ; then
	echo White list generation will take a few minutes...
	echo It only needs to be run once.
	echo // A white list of symbols defined by Flex which we should not clobber. > $listpath/$whitelist
	echo // Generated with 'make whitelist' >> $listpath/$whitelist
	make whitelist >> $listpath/$whitelist
	echo >> $listpath/$whitelist
fi

echo // A list of application-defined symbols to obfuscate. > $listpath/$blacklist
echo // Generated with 'obfuscate.sh' >> $listpath/$blacklist
make clean release prettyprint=true
make obfuscate >> $listpath/$blacklist
echo // Undefine any symbols the same as system calls >> $listpath/$blacklist
echo \#include \"$whitelist\" >> $listpath/$blacklist
echo >> $listpath/$blacklist
make CFG=release all
make CFG=profile
make CFG=debug


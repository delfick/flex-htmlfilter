#
# It's the Flex 2 GNU Makefile!
# I might have used 'ant', but I already know 'make'.
# Requirements: GNU make, GNU sed, GNU cpp
#
# For Mac/Linux users, there are some Windows/CMD.exe dependencies to 'fix'
# These are commented where they occur
#

# Include, translate and export shared project settings
include configure.mak
export TARGET	:= $(subst \,/,$(TARGET))
export ASMAIN	:= $(subst \,/,$(ASMAIN))
export ROOTDIR	:= $(subst \,/,$(ROOTDIR))
export LIBDIRS	:= $(subst \,/,$(LIBDIRS))
export INCLUDES	:= $(subst \,/,$(INCLUDES))
export ASSETDIR	:= $(subst \,/,$(ASSETDIR))
export INDENTFLAGS := $(subst \,/,$(INDENTFLAGS))
export prettyprint

ifeq "$(OS)" "Windows_NT"
export SED		:= $(subst /,\,$(SED))
export ZIPTOOL	:= $(subst /,\,$(ZIPTOOL))
export INDENT	:= $(subst /,\,$(INDENT))
export CPPFILTER:= filters\cppfilter.exe
else
export SED		:= $(subst \,/,$(SED))
export ZIPTOOL	:= $(subst \,/,$(ZIPTOOL))
export INDENT	:= $(subst \,/,$(INDENT))
export CPPFILTER:= filters/cppfilter
endif

# Flags for preprocessor (Preserve comments, look in include folder)
CPPFLAGS			:= -C -x c -I $(INCLUDES)

# A list of targets that should always be run 
.PHONY: all clean cleaner zip whitelist obfuscate symbols

##################################
#
# Warn about 
# 

ifeq "$(OS)" ""
ifeq "$(OSTYPE)" ""
	$(warning OS or OSTYPE not set!  Defaults to POSIX)
else
OS := $(OSTYPE)
endif
endif


##################################
#
# A 'help' rule
# 
none_specified: release
	$(info -------------------------------------------------------------------)
	$(info No target specified.)
	$(info Defaulted to: make debug)
	$(info Possible targets...)
	$(info 	make release      Build release mode swf - default)
	$(info 	make debug        Build debug mode swf)
	$(info 	make profile      Build profiler mode swf)
	$(info 	make all          Rebuild debug/release)
	$(info 	make run          Build+run the swf)
	$(info 	make rundebug     Build+run the debug swf in fdb)
	$(info 	make runprofile   Build+run profiler mode swf)
	$(info 	make runhtml      Build+run the swf in the browser)
	$(info 	make clean        Wipe out intermediate files)
	$(info 	make cleaner      Invoke clean on subdirectories)
	$(info 	make zip          Archive project with Info-zip)
	$(info 	make prettyprint=true [target]  Use GNU indent on preprocessed code)
	$(info -------------------------------------------------------------------)

##################################
#
# Make optimized build
#

release:
	$(MAKE) -r -R -f cpp2mxmlc.mak \
	CPPFLAGS='$(CPPFLAGS) $(CLIFLAGS) -DNDEBUG $(EDITOR) $(CD)' \
	MXMLFLAGS='$(MXML_FLAGS) -compiler.debug=false -compiler.optimize=true' \
		ASPATH='as' \
		BIN='$(ROOTDIR)'

##################################
#
# Make profiled, optimized build
#
profile: 
	$(MAKE) -r -R -f cpp2mxmlc.mak \
	CPPFLAGS='$(CPPFLAGS) $(CLIFLAGS) -DPROFILE -DNDEBUG' \
	MXMLFLAGS='$(MXML_FLAGS) -compiler.debug=false -compiler.optimize=true' \
		ASPATH='asp' \
		BIN='$(ROOTDIR)'

##################################
#
# Make debug/instrumented build
#
debug:
	$(MAKE) -r -R -f cpp2mxmlc.mak \
	CPPFLAGS='$(CPPFLAGS) $(CLIFLAGS) -DDEBUG' \
	MXMLFLAGS='$(MXML_FLAGS) -compiler.debug=true -compiler.optimize=false' \
		ASPATH='asd' \
		BIN='$(ROOTDIR)'

##################################
#
# Make fresh copies of all targets
#
all: clean debug profile release 

##################################
#
# Build and run release mode
#
run: release 
	$(info Running release target)
ifeq "$(OS)" "Windows_NT"
	cmd /c "bin\$(TARGET)"
else
# Mac/Linux/POSIX: Do whatever it is that makes the SWF play
# CAUTION: Make sure right SWF player is associated to this file!
	firefox bin/test.html
endif

##################################
#
# Build and run release mode
#
runprofile: profile
	$(info Running profile target)
ifeq "$(OS)" "Windows_NT"
	cmd /c "binp\$(TARGET)"
else
# Mac/Linux/POSIX: Do whatever it is that makes the SWF play
# CAUTION: Make sure right SWF player is associated to this file!
	firefox binp\$(TARGET)
endif

##################################
#
# Build and run release mode
#
runhtml: release 
	$(info Running release target in browser)
ifeq "$(OS)" "Windows_NT"
	cmd /c "bin\test.html"
else
# Mac/Linux/POSIX: Do whatever it is that makes the SWF play
# CAUTION: Make sure right SWF player is associated to this file!
	firefox bin\$(TARGET)
endif

##################################
#
# Build and debug
#
rundebug: debug
	$(info Running debug target)
ifeq "$(OS)" "Windows_NT"
	fdb bind/$(TARGET)
else
# Mac/Linux/POSIX: Do whatever it is that invokes your debugger
# CAUTION: Make sure right SWF player is associated to this file!
	fdb bind/$(TARGET)
endif

##################################
#
# Nuke all intermediate files
#
clean: 
	-@rm -rf bin as binp asp bind asd errors base/*.swf $(CPPFILTER)

##################################
#
# Find makefiles in subdirectories and clean them, too
#
cleaner:
	@find . -name Makefile -execdir $(MAKE) -s -f \{\} clean \;

##################################
#
# Put source in an archive
#
zip: cleaner
ifeq "$(OS)" "Windows_NT"
	@-rm -f $(CURDIR).zip
	@zip -r $(CURDIR).zip .
else
	@-rm -f $(CURDIR).zip
	@find . -type f | sed -n -e '/\/\./!p' | xargs zip '$(CURDIR).zip'  
endif

##################################
#
# Make a list of classes, functions 
# and class member variables.
#
symbols:
	@find src -name '*.as' -exec sed -n \
		-e 's/^.*function[ \t]*\b\(set\|get\)\b[ \t]*\([A-Za-z0-9_]*\)*$$/\2/p'\
		-e 's/^.*function \([A-Za-z0-9_]*\).*$$/\1/p' \
		-e 's/^.*\b\(var\|const\)\b[ \t]*\([A-Za-z0-9_]*\).*$$/\2/p' \
		'{}' \;

##################################
#
# Make a list of symbols (except constructors),
# sort them, remove duplicates, remove extra
# whitespace, #define them to _1, _2, _3...
# In other words, auto-generate an obfuscate.h
# to turn release-mode code into spaghetti drool.
#
obfuscate:
	@find as -name '*.as' -exec \
		sed -n \
			-e 's/^.*function[ \t]*\b\(set\|get\)\b[ \t]*\([A-Za-z0-9_]*\)*$$/\2/p' \
			-e 's/^.*function[ \t]*\([A-Za-z0-9_]*\)[ \t]*(.*).*:.*$$/\1/p' \
			-e 's/^.*\b\(var\|const\)\b[ \t]*\([A-Za-z0-9_]*\).*:.*$$/\2/p' \
			'{}' \; \
	   	| sort \
		| sed '$!N; /^\(.*\)\n\1$$/!P; D' \
		| sed -e 's/[ \t]*$$//' -e 's/^/#define /' \
		| sed -n -e '/.*/ p;=' \
		| sed -e 'N;s/\n/ _/'

##################################
#
# Make a list of symbols NOT to obfuscate
# sort them, remove duplicates, remove extra
# whitespace, #undef them
#
# Note: The regular expressions are more 'picky' to exclude abberent matches
# found in the comments among the symbols.  Private and internal types are 
# skipped.
# 
# This is the site I grabbed the AS3 intrinsics from...
fromwhere=http://www.flashdevelop.org/downloads/releases/archive
# This is the file name
filename=AS3_intrinsic_classes.zip
# This is the tree to unzip into
intrinsics=_intrinsics

whitelist:
	@wget --timestamping $(fromwhere)/$(filename) > /dev/null
	@unzip -u -d $(intrinsics) $(filename) > /dev/null
	@find $(intrinsics) -name '*.as' -exec \
		sed -n \
		 	-e 's#^.*\bfunction[ \t]*\b\(set\|get\)\b[ \t]*\([A-Za-z0-9_]*\).*$$#\2#p' \
			-e 's#^.*\bfunction[ \t]*\([A-Za-z0-9_]*\)[ \t]*(.*).*:.*$$#\1#p' \
			-e 's#^.*\b\(var\|const\)\b[ \t]*\([A-Za-z0-9_]*\).*$$#\1#p' \
		'{}' \;\
	   	| sort \
		| sed '$!N; /^\(.*\)\n\1$$/!P; D' \
		| sed '/./!d'\
		| sed -e 's/[ \t]*$$//' -e 's/^/#undef /'
	@rm -rf $(intrinsics)
#	@rm $(filename)
	
##################################
#
# Tell make to 'sleep'.
# jEdit runs macros without waiting
# for file operations to complete
#
sleep:
	sleep 1


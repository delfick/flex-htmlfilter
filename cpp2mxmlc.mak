.SUFFIXES: .mxml .as .h .swf .swc

# Make a list of all of the source directories for AS3 content
SRCDIRS		:=$(ROOTDIR) $(LIBDIRS) 

# Makefile dependencies; build if we edit the makefiles
MakeDeps	:= Makefile cpp2mxmlc.mak configure.mak

# Make a list of AS source directories from SRCDIRS (AS3)
ASDIRS	= $(subst $(ROOTDIR),$(ASPATH),$(SRCDIRS))

# Make a list of AS3 files
FILES.AS= $(foreach dir,$(SRCDIRS),$(wildcard $(dir)/*.as))

# Make a list of AS files from the original list of AS3 files
FILES.DAS := $(subst $(ROOTDIR),$(ASPATH),$(FILES.AS))

# Make a list of AS3 files
FILES.mxml= $(foreach dir,$(SRCDIRS),$(wildcard $(dir)/*.mxml))

# Make a list of mxml files in target directory from the original list of mxml files
FILES.Dmxml := $(subst $(ROOTDIR),$(ASPATH),$(FILES.mxml))

# Make a list of include file dependencies
INCDEPS = $(wildcard $(INCLUDES)/*.h) $(foreach dir,$(SRCDIRS),$(wildcard $(dir)/*.h)) 

# Make a model of CURDIR that's compatible with sed command line
CURDIR.SED := $(subst /,\/,$(CURDIR))

MXMLC	=mxmlc


##################################
#
# Default mxmlc target rule
#
$(BIN)/$(TARGET): $(BIN) $(ASPATH) $(CPPFILTER) $(FILES.DAS) $(FILES.Dmxml) $(MakeDeps)
	$(info Update binaries)
ifdef prettyprint
	$(MXMLC) $(MXMLFLAGS) -o $@ $(ASPATH)/$(ASMAIN) 
else
# Remove final target to flag its un-built status
	-@rm -f $(BIN)/$(TARGET)
# Make error/warning paths point at original file
# 1. -e "s/\\/\//g" Force DOS paths to '/' paths.
# 2. -e (long spew) Force ProjectPath/$(SRCDIR)/ to ProjectPath/$(ASPATH)/
# Mac/Linux/POSIX: Remove first -e "s/\\/\//g", if you like
# Report error if the target does not exist.
	$(MXMLC) $(MXMLFLAGS) -o $@ $(ASPATH)/$(ASMAIN) >errors 2>&1
ifeq "$(OS)" "Windows_NT" 
	$(SED) -e "s/\\/\//g" -e "s/$(CURDIR.SED)\/$(ASPATH)/$(CURDIR.SED)\/$(ROOTDIR)/I"  errors
# Generates an error level if this fails
	test -f $(BIN)/$(TARGET)
else
	$(SED) -e 's/$(CURDIR.SED)\/$(ASPATH)/$(CURDIR.SED)\/$(ROOTDIR)/' errors
	if test ! -f $(BIN)/$(TARGET); then exit 2 ; fi
endif
endif 
	@echo Success!

##################################
#
# Pattern rule to preprocess .as files
#
$(ASPATH)/%.as: $(ROOTDIR)/%.as $(MakeDeps) $(INCDEPS)
ifdef prettyprint
	cpp -nostdinc $(CPPFLAGS) $< | $(CPPFILTER) -gcc | $(INDENT) $(INDENTFLAGS)> $@
	@$(SED) -i -e "s/(  )/()/g" $@ 
else
	cpp -nostdinc $(CPPFLAGS) $< | $(CPPFILTER) -gcc > $@
endif

##################################
#
# Pattern rule to preprocess .mxml files
#
$(ASPATH)/%.mxml: $(ROOTDIR)/%.mxml $(MakeDeps) $(INCDEPS)
ifdef prettyprint
	cpp -nostdinc $(CPPFLAGS) $< | $(CPPFILTER) -gcc | $(INDENT) $(INDENTFLAGS)> $@
	@$(SED) -i -e "s/(  )/()/g" $@ 
else
	cpp -nostdinc $(CPPFLAGS) $< | $(CPPFILTER) -gcc > $@
endif

##################################
#
# Make and populate target preprocessed tree
#
$(ASPATH): $(ROOTDIR)/*
ifeq "$(OS)" "Windows_NT"
	@xcopy /I /C /K /Y /R /E /D "$(ROOTDIR)" "$(ASPATH)"
else
	@-find $(ROOTDIR) -type d | $(SED) -n -e 's/^$(ROOTDIR)/$(ASPATH)/' -e '/\/\./!p' | grep -v $(ASSETDIR) | xargs mkdir
	ln -s $(CURDIR)/$(ROOTDIR)/$(ASSETDIR) $(ASPATH) -f
endif

##################################
#
# I need this little filter, so I'll just build it.
#
ifeq "$(OS)" "Windows_NT" 
$(CPPFILTER): $(subst .exe,.c,$(CPPFILTER)) $(MakeDeps)
	gcc -o $@ $<
else
$(CPPFILTER): $(patsubst %,%.c,$(CPPFILTER)) $(MakeDeps)
	gcc -o $@ $<
endif


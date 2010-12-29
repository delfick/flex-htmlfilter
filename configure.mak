#
# Common settings for Makefile and nmake.mak
# Running this by its self is harmless, but will accomplish nothing.
#

# Flags to pass to MXML
MXML_FLAGS=\
	-use-network=false  \
	-keep-as3-metadata+=Style \
#	-metadata.creator='David Mace'\
#	-metadata.description="Work in Progress"\
#	-metadata.language="EN"\
#	-metadata.publisher="Your name here?"\
#	-metadata.title="Test Toys"\
#	-metadata.contributor=""\
#	-metadata.date=""\
#	-metadata.localized-description <text> <lang>\
#	-metadata.localized-title <title> <lang>\


TYPE	=index

# Final output file name
TARGET		=$(TYPE).swf

# Main as file that mxmlc will be starting from
ASMAIN		=$(TYPE).mxml


# Root directory of all source files
ROOTDIR		=base

# directory for assets
ASSETDIR	=assets

# Where else to look for source code to preprocess and transfer
# Where mxmlc will be searching imports under $(ROOTDIR), add those dirs here.
# Space separated list
# NOTE: 'find -type d' or 'dir /s /b /ad' will give you the same list
LIBDIRS		= \
	$(ROOTDIR)/com \
	$(ROOTDIR)/com/htmlFilter \
	$(ROOTDIR)/com/htmlFilter/special \
	$(ROOTDIR)/com/interactiveAlchemy\
	$(ROOTDIR)/com/interactiveAlchemy/utils\
	$(ROOTDIR)/qs \
	$(ROOTDIR)/qs/utils \
	$(ROOTDIR)/qs/controls \
	$(ROOTDIR)/qs/caching 


# Include path for common preprocessor definitions
INCLUDES	=$(ROOTDIR)/include

# Where to find sed, zip, other tools (default: search PATH)
SED			=sed
ZIPTOOL		=zip
INDENT		=indent

# Flags to pass to indent (if enabled)
INDENTFLAGS	= -i4 --tab-size4 -l512 -bl -sob -cli0 -bli0 -npcs -prs



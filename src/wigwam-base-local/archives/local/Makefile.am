localdir=@prefix@/libexec/archives/local

local_SCRIPTS =				\
	get

.%.syntax: %
	ash -n $*
	touch .$*.syntax

if CHECK_SYNTAX
noinst_DATA = $(patsubst %, .%.syntax, ${local_SCRIPTS})
endif

EXTRA_DIST = $(local_SCRIPTS)

CLEANFILES = $(wildcard .*.syntax)

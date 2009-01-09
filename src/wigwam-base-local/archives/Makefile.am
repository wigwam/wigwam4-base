SUBDIRS = BASE local

funcdir=@prefix@/libexec/archives

func_DATA = functions

.%.syntax: %
	ash -n $*
	touch .$*.syntax

if CHECK_SYNTAX
noinst_DATA = $(patsubst %, .%.syntax, ${func_DATA})
endif

EXTRA_DIST = $(func_DATA)

CLEANFILES = $(wildcard .*.syntax)

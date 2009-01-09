basedir=@prefix@/libexec/archives/BASE

base_SCRIPTS = 			\
	pre-get			\
	get			\
	post-get

.%.syntax: %
	ash -n $*
	touch .$*.syntax

if CHECK_SYNTAX
noinst_DATA = $(patsubst %, .%.syntax, ${base_SCRIPTS})
endif

EXTRA_DIST = $(base_SCRIPTS)

CLEANFILES = $(wildcard .*.syntax)

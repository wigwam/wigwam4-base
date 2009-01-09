shdir=@prefix@/libexec/functions

shnongenerated=			\
	configurable-functions	\
	debug-hook

shgenerated=			\
	sh-macros		\
  	wigwam-base-functions

sh_DATA = 			\
  	$(shgenerated)		\
	$(shnongenerated)

.%.syntax: %
	ash -n $*
	touch .$*.syntax

if CHECK_SYNTAX
noinst_DATA = $(patsubst %, .%.syntax, ${sh_DATA})
endif

EXTRA_DIST = 					\
	$(patsubst %, %.in, $(shgenerated))	\
	$(shnongenerated)

CLEANFILES = 			\
	$(shgenerated)		\
	$(wildcard .*.syntax)

install-data-hook:
	rm -f "$(DESTDIR)$(prefix)/bin/sh-macros"
	ln -sf "$(DESTDIR)$(shdir)/sh-macros" "$(DESTDIR)$(prefix)/bin"

makedir=@prefix@/libexec/packagectl/make

# install is named install.mega because otherwise make gets confused

makegenerated=

makenongenerated=		\
	build			\
	install.mega

make_SCRIPTS = 			\
  	$(makegenerated)	\
	$(makenongenerated)

.%.syntax: %
	ash -n $*
	touch .$*.syntax

if CHECK_SYNTAX
noinst_DATA = 	$(patsubst %, .%.syntax, ${make_SCRIPTS})
endif

EXTRA_DIST = 			\
	$(makenongenerated)

CLEANFILES = 			\
	$(makegenerated)	\
	$(wildcard .*.syntax)

install-data-hook:
	mv "$(DESTDIR)$(makedir)/install.mega" \
	   "$(DESTDIR)$(makedir)/install"

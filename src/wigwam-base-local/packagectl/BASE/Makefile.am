basedir=@prefix@/libexec/packagectl/BASE

# install is named install.mega because otherwise make gets confused
# uninstall is named uninstall.mega because otherwise make gets confused

basenongenerated=		\
	check-system		\
	download		\
	pre-install		\
	install.mega		\
	post-install		\
	reinstall		\
	uninstall.mega		\
	unpack			\
	upgrade

basegenerated=

base_SCRIPTS = 			\
  	$(basegenerated)	\
	$(basenongenerated)

base_DATA =			\
  	functions

.%.syntax: %
	ash -n $*
	touch .$*.syntax

if CHECK_SYNTAX
noinst_DATA = 	$(patsubst %, .%.syntax, ${func_SCRIPTS})	\
		$(patsubst %, .%.syntax, ${base_SCRIPTS})	\
  		$(patsubst %, .%.syntax, ${base_DATA})
endif

EXTRA_DIST = 			\
	$(base_DATA)		\
	$(basenongenerated)

CLEANFILES = 			\
	$(basegenerated)	\
	$(wildcard .*.syntax)

install-data-hook:
	mv "$(DESTDIR)$(basedir)/install.mega" 		\
	   "$(DESTDIR)$(basedir)/install"
	mv "$(DESTDIR)$(basedir)/uninstall.mega" 	\
	   "$(DESTDIR)$(basedir)/uninstall"
